import Combine
import Foundation

protocol SeasonListViewModelRepresentable: ObservableObject {
    
    var state: SeasonListViewModel.State { get }
    var route: [SeasonListViewModel.Route] { get set }
    var action: PassthroughSubject<SeasonListViewModel.Action, Never> { get }
}

class SeasonListViewModel: SeasonListViewModelRepresentable {
    
    private var drivers: [Driver]
    private var constructors: [Constructor]
    private var events: [Event]
    private var nextEvent: Event?
    private let eventService: EventServiceRepresentable
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let liveEventService: LiveSessionServiceRepresentable
    private var subscriptions = Set<AnyCancellable>()
    private var timer: Timer? = nil
    
    @Published var cells: [Section] = []
    
    @Published var state: State
    @Published var route: [Route]
    @Published var upcomingAndStandingsFilter: UpcomingAndStandingsEventCellViewModel.Filter = .upcoming
    var action = PassthroughSubject<Action, Never>()
    
    init(
        driverAndConstructorService: DriverAndConstructorServiceRepresentable,
        eventService: EventServiceRepresentable,
        liveEventService: LiveSessionServiceRepresentable
    ) {
        
        self.drivers = []
        self.constructors = []
        self.events = []
        self.eventService = eventService
        self.driverAndConstructorService = driverAndConstructorService
        self.liveEventService = liveEventService
        self.state = .loading([])
        self.route = []
        self.nextEvent = nil
        
        load()
    }
    
    // MARK: - Private
    private func load() {
        
        eventService.action.send(.fetchAll)
        
        liveEventService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] liveEventService in
                
                guard
                    let self,
                    let index = self.cells.firstIndex(where: { $0.id == Section.idValue.live.rawValue })
                else {
                    return
                }
                
                switch liveEventService {
                case .refreshed(let livePostions):
                    self.state = self.loadData(livePositions: livePostions, fetchLivePositions: false)
                    
                case .refreshing, .error:
                    self.cells[index] = .live(LiveCardCellViewModel.mockLiveAboutToStart, isLoading: true)
                    self.state = .results(self.cells)
                }
                
            }
            .store(in: &subscriptions)
        
       eventService.statePublisher
            .combineLatest(driverAndConstructorService.statePublisher)
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] eventService, driverAndConstructorService -> SeasonListViewModel.State? in

                guard let self else { return nil }
                
                switch (eventService, driverAndConstructorService) {
                case (.error(let error), _), (_, .error(let error)):
                    return .error(error.localizedDescription)

                case (.refreshed(let events, let nextEvent), .refreshed(let drivers, let constructors)):
                    self.constructors = constructors
                    self.drivers = drivers
                    self.events = events
                    self.nextEvent = nextEvent
                    return self.loadData(fetchLivePositions: self.cells.isEmpty)

                case (.refreshing, _), (_, .refreshing):
                    return self.cells.isEmpty ? .loading(Section.cellsLoading) : .results(self.cells)
                }
            }
            .assign(to: &$state)
    }
    
    private func loadData(
        livePositions: [LivePosition] = [],
        fetchLivePositions: Bool
    ) -> State {
        
        cells = []
        var upcomingEvents: [Event.Details] = []
        
        guard let nextEvent else { return .error("No next event") }
        
        if fetchLivePositions { liveEventService.action.send(.fetchPositions) }
        
        events.enumerated().forEach { [weak self] (index, event) in
            
            guard let self else { return }
            
            var livePostionsTransform: [Driver] = []
            
            if !livePositions.isEmpty {
                livePostionsTransform = livePositions.lazy.compactMap { [weak self] position in
                    
                    guard
                        let self,
                        position.position <= 3,
                        let driver = self.drivers.first(where: { $0.id == position.id })
                    else {
                        return nil
                    }
                    
                    return driver
                }
            }
            
            let eventStatus = Event.getEventStatus(
                for: event,
                comparing: nextEvent,
                drivers: self.drivers,
                liveDrivers: livePostionsTransform
            )
            
            // Live CELL
            if case .live(let timeInterval, _, _) = eventStatus {
                
                self.timer?.invalidate()
                
                self.updateTodayEvent(livePositions: livePositions, timeInterval: timeInterval)
                
                if fetchLivePositions {
                    cells.append(.live(LiveCardCellViewModel.mockLiveAboutToStart, isLoading: true))
                } else {
                    let eventDetail: Event.Details = .init(
                        status: eventStatus,
                        round: event.round,
                        title: event.title,
                        country: event.country
                    )
                    
                    cells.append(.live(buildLiveViewModel(with: eventDetail, index: index)))
                }
            } else {
                upcomingEvents.append(
                    .init(
                        status: eventStatus,
                        round: event.round,
                        title: event.title,
                        country: event.country
                    )
                )
            }
            
        }
        
        cells.append(.upcomingAndStandings(buildUpcomingAndStandingsViewModel(with: upcomingEvents)))
        
        return .results(cells)
    }
    
    private func buildLiveViewModel(with eventDetails: Event.Details, index: Int) -> LiveCardCellViewModel {
        
        let viewModel: LiveCardCellViewModel = .init(eventDetail: eventDetails, drivers: drivers)
        
        viewModel.action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard case .results = self?.state else { return }
                self?.tapRow(at: index)
            }
            .store(in: &subscriptions)
        
        return viewModel
        
        
    }
    
    private func buildUpcomingAndStandingsViewModel(
        with eventDetails: [Event.Details]
    ) -> UpcomingAndStandingsEventCellViewModel {
        
        let viewModel = UpcomingAndStandingsEventCellViewModel(
            eventDetails: eventDetails,
            drivers: drivers,
            constructors: constructors,
            filter: upcomingAndStandingsFilter
        )
        
        viewModel.action
            .receive(on: DispatchQueue.main)
            .compactMap {
                switch $0 {
                case .filterEvent(let filter): return filter
                }
            }
            .assign(to: &$upcomingAndStandingsFilter)
        
        return viewModel
            
    }
    
    private func tapRow(at index: Int) {
        
        let sessionStandingsVM: SessionStandingsListViewModel = .init(event: events[index])
        
        route.append(.sessionStandings(sessionStandingsVM))
    }
    
    private func updateTodayEvent(livePositions: [LivePosition] = [], timeInterval: TimeInterval) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
            
            guard let self else { return }
            
            if timeInterval > 0 || livePositions.isEmpty {
                self.eventService.action.send(.updateAll)
            }
            
            if timeInterval <= 0 {
                self.liveEventService.action.send(.updatePositions)
            }
        }
    }
}

extension SeasonListViewModel {
    
    enum State: Equatable {
        
        static func == (lhs: SeasonListViewModel.State, rhs: SeasonListViewModel.State) -> Bool {
            lhs.id == rhs.id
        }
        
        case error(String)
        case results([Section])
        case loading([Section])
        
        enum idValue: String {
            
            case error
            case loading
            case results
        }
        
        var id: String {
            
            switch self {
            case .loading: return idValue.loading.rawValue
            case .results: return idValue.results.rawValue
            case .error: return idValue.error.rawValue
            }
        }
    }
    
    enum Action {
        
        case tap(index: Int)
    }
    
    enum Route: Hashable {
        
        static func == (lhs: SeasonListViewModel.Route, rhs: SeasonListViewModel.Route) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        case sessionStandings(SessionStandingsListViewModel)
        
        var id: String {
            switch self {
            case .sessionStandings: return "sessionStandings"
            }
        }
    }
    
    enum Section: Equatable, Identifiable {
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
        
        static let cellsLoading: [Self] = [
            .live(LiveCardCellViewModel.mockLiveAboutToStart, isLoading: true),
            .upcomingAndStandings(
                .init(
                    eventDetails: Event.mockDetailsArray,
                    drivers: Driver.mockArray,
                    constructors: Constructor.mockArray,
                    filter: .upcoming
                )
            )
        ]
        
        case live(LiveCardCellViewModel, isLoading: Bool = false)
        case upcomingAndStandings(UpcomingAndStandingsEventCellViewModel)
        
        enum idValue: String {
            case live = "live"
            case upcomingAndStandings = "upcomingAndStandings"
        }
        
        var id: String {
            
            switch self {
            case .live: return idValue.live.rawValue
            case .upcomingAndStandings: return idValue.upcomingAndStandings.rawValue
            }
        }
    }
}

extension SeasonListViewModel {
    
    static func make() -> SeasonListViewModel {
        
        .init(
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService,
            eventService: ServiceLocator.shared.eventService,
            liveEventService: ServiceLocator.shared.liveSessionService
        )
    }
}
