import Combine
import Foundation
import OSLog

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
    private var timerEvents: Timer? = nil
    private var timesToRefreshEvents: Int = 0
    private var firstReload: Bool = true
    
    @Published var cells: [Section]
    
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
        self.cells = Section.cellsLoading
        
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
                case .refreshed(let livePositions):
                    
                    self.loadLiveData(livePositions: livePositions)
                    
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

                case (.refreshed(let events), .refreshed(let drivers, let constructors)):
                    self.constructors = constructors
                    self.drivers = drivers
                    self.events = events
                    return self.loadData()

                case (.refreshing, _), (_, .refreshing):
                    return .results(self.cells)
                }
            }
            .assign(to: &$state)
    }
    
    private func loadData() -> State {
        
        var upcomingEvents: [Event.ShortDetails] = []
        
        if firstReload {
            liveEventService.action.send(.fetchPositions)
            firstReload = false
        }
        
        events.enumerated().forEach { (index, event) in

            if event.status.id != Event.Status.idValue.live.rawValue {
                upcomingEvents.append(
                    .init(
                        status: event.status,
                        round: event.round,
                        title: event.title,
                        country: event.country
                    )
                )
            }
            
        }
        
        timerEvents?.invalidate()
        updateEvents()
        
        if !events.contains(where: { $0.status.id == Event.Status.idValue.live.rawValue }) {
            cells = [.upcomingAndStandings(buildUpcomingAndStandingsViewModel(with: upcomingEvents))]
        } else if let cellIndex = cells.firstIndex(where: { $0.id == Section.idValue.upcomingAndStandings.rawValue }) {
            cells[cellIndex] = .upcomingAndStandings(buildUpcomingAndStandingsViewModel(with: upcomingEvents))
        }
        
        return .results(cells)
    }
    
    private func loadLiveData(livePositions: [LivePosition] = []) {
        
        guard
            let index = self.cells.firstIndex(where: { $0.id == Section.idValue.live.rawValue }),
            let nextLiveEventIndex = events
                .firstIndex(where: { $0.status.id == Event.Status.idValue.live.rawValue }),
            case .live(let timeInterval, _) = self.events[nextLiveEventIndex].status
        else {
             return
        }
        
        cells[index] = .live(
            buildLiveViewModel(with: events[nextLiveEventIndex].shortDetails, index: index, livePositions: livePositions)
        )
        
        if timeInterval < 0 && livePositions.isEmpty {
            timerEvents?.invalidate()
            updateEvents(force: true)
        }
        
        timer?.invalidate()
        
        updateTodayEvent(timeInterval: timeInterval)
        
        state = .results(cells)
    }
    
    private func buildLiveViewModel(
        with eventDetails: Event.ShortDetails,
        index: Int,
        livePositions: [LivePosition]
    ) -> LiveCardCellViewModel {
        
        var liveDrivers: [Driver] = []
        
        if !livePositions.isEmpty {
            liveDrivers = livePositions.lazy.compactMap { [weak self] position in
                
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
        
        let viewModel: LiveCardCellViewModel = .init(eventDetail: eventDetails, drivers: liveDrivers)
        
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
        with eventDetails: [Event.ShortDetails]
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
        
        let sessionStandingsVM: SessionStandingsListViewModel = .make(event: events[index])
        
        route.append(.sessionStandings(sessionStandingsVM))
    }
    
    private func updateTodayEvent(livePositions: [LivePosition] = [], timeInterval: TimeInterval) {
        
        timer = Timer.scheduledTimer(
            withTimeInterval: timeInterval > 0 && timeInterval < .hourInterval && livePositions.isEmpty ? 1 : 10,
            repeats: false
        ) { [weak self] _ in
            
            guard let self else { return }
            
            if timeInterval <= 0 {
                self.liveEventService.action.send(.updatePositions)
            } else {
                self.loadLiveData()
            }
        }
    }
    
    private func updateEvents(force: Bool = false) {
        
        if force {
            eventService.action.send(.updateAll)
            return
        }
        
        timerEvents = Timer.scheduledTimer(withTimeInterval: 55, repeats: false) { [weak self] _ in
            
            guard let self else { return }
            
            self.timesToRefreshEvents += 1
            
            if self.timesToRefreshEvents == 5 {
                self.timesToRefreshEvents = 0
                self.eventService.action.send(.updateAll)
            } else {
                Logger.eventService.debug("Loading current events cells \(self.timesToRefreshEvents)")
                self.state = self.loadData()
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
