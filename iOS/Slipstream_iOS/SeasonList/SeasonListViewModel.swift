import Combine
import Foundation

protocol SeasonListViewModelRepresentable: ObservableObject {
    
    var state: SeasonListViewModel.State { get }
    var route: [SeasonListViewModel.Route] { get set }
    var action: PassthroughSubject<SeasonListViewModel.Action, Never> { get }
    var filters: [SeasonListViewModel.UpcomingOrPastFilter] { get }
    var upcomingOrPastSelection: SeasonListViewModel.UpcomingOrPastFilter { get }
}

class SeasonListViewModel: SeasonListViewModelRepresentable {
    
    private var drivers: [Driver]
    private var constructors: [Constructor]
    private var events: [Event]
    private var nextEvent: Event?
    private var finishedEvents: [GrandPrixCardViewModel] = []
    private var upcomingEvents: [GrandPrixCardViewModel] = []
    private let eventService: EventServiceRepresentable
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let liveEventService: LiveSessionServiceRepresentable
    private var subscriptions = Set<AnyCancellable>()
    private var timer: Timer? = nil
    private var updatedIndex: Int? = nil
    
    @Published var cells: [Section] = []
    
    @Published var state: State
    @Published var route: [Route]
    let filters: [UpcomingOrPastFilter] = UpcomingOrPastFilter.allCases
    @Published var upcomingOrPastSelection: UpcomingOrPastFilter = .upcoming
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
        
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                
                guard let self else { return }
                
                switch action {
                case .tap(let index):
                    self.tapRow(at: index)
                case .filterEvent(let filter):
                    self.upcomingOrPastSelection = filter
                    self.buildUpcomingViewModel(for: filter == .upcoming ? self.upcomingEvents : self.finishedEvents)
                }
            }
            .store(in: &subscriptions)
        
        liveEventService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] liveEventService in
                
                guard let self else { return }
                
                switch liveEventService {
                case .refreshed(let livePostions):
                    self.state = self.loadData(livePositions: livePostions, fetchLivePositions: false)
                    
                case .refreshing, .error:
                    if let index = self.cells.firstIndex(where: { $0.id == Section.idValue.live.rawValue }) {
                        
                        self.cells[index] = .live(LiveCardCellViewModel.mockLiveSoonHours, index: nil)
                                                  
                        self.state = .results(self.cells)
                    }
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
    
    private func buildStandingsViewModel(for drivers: [Driver]) {
        
        if let index = cells.firstIndex(where: { $0.id == Section.idValue.upcomingAndStandings.rawValue }),
           case .upcomingAndStandings(let upcomingVM) = cells[index],
           let standingsIndex = upcomingVM.cells
            .firstIndex(where: { $0.id  == UpcomingAndStandingsEventCellViewModel.Cell.idValue.standings.rawValue }) {
            
            upcomingVM.cells[standingsIndex] = .standings(drivers, constructors)
            cells[index] = .upcomingAndStandings(upcomingVM)
        }
        
        state = .results(cells)
    }
    
    private func buildUpcomingViewModel(for events: [GrandPrixCardViewModel]) {
        
        if let index = cells.firstIndex(where: { $0.id == Section.idValue.upcomingAndStandings.rawValue }),
           case .upcomingAndStandings(let upcomingVM) = cells[index],
           let upcomingIndex = upcomingVM.cells
            .firstIndex(where: { $0.id  == UpcomingAndStandingsEventCellViewModel.Cell.idValue.upcoming.rawValue }) {
            
            upcomingVM.cells[upcomingIndex] = .upcoming(events)
            cells[index] = .upcomingAndStandings(upcomingVM)
        }
        
        state = .results(cells)
    }
    
    private func loadData(
        livePositions: [LivePosition] = [],
        fetchLivePositions: Bool
    ) -> State {
        
        cells = []
        finishedEvents = []
        upcomingEvents = []
        
        guard let nextEvent else { return .error("No next event") }
        
        if fetchLivePositions { liveEventService.action.send(.fetchPositions) }
        
        events.enumerated().forEach { (index, event) in
            
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
            if case .live(let timeInterval, let sessionName, let drivers) = eventStatus {
                
                self.timer?.invalidate()
                self.updatedIndex = index
                
                self.updateTodayEvent(livePositions: livePositions, timeInterval: timeInterval)
                
                if fetchLivePositions {
                    cells.append(.live(LiveCardCellViewModel.mockLiveSoon, index: nil))
                } else {
                    cells.append(
                        .live(
                            .init(
                                topSection: LiveCardCellViewModel.TopSection(title: event.name, round: event.round),
                                cardSection: LiveCardCellViewModel.CardSection(
                                    title: sessionName,
                                    status: nil,
                                    drivers: drivers
                                ),
                                timeInterval: timeInterval
                            ),
                            index: index
                        )
                    )
                }
            }
            
            if case .upcoming(let start, let end, let session, let timeInterval) = eventStatus {
                
                let threeDaysInterval: Double = 3*24*60*60
                
                self.upcomingEvents.append(
                    .init(
                        round: event.round,
                        title: event.name,
                        subtitle: "Italy",
                        grandPrixDate: timeInterval ?? threeDaysInterval < threeDaysInterval
                            ? session
                            : start + " - " + end,
                        nextSession: timeInterval
                    )
                )
                
            }
            
            if case .finished(let winner) = eventStatus {
                
                self.finishedEvents.append(
                    .init(
                        round: event.round,
                        title: event.name,
                        subtitle: "Italy",
                        grandPrixDate: "Winner: " + winner,
                        nextSession: nil
                    )
                )
            }
        }
        
        cells.append(
            .upcomingAndStandings(
                .init(
                    upcoming: upcomingOrPastSelection == .upcoming ? upcomingEvents : finishedEvents,
                    drivers: drivers,
                    constructors: constructors
                )
            )
        )
        
        return .results(cells)
    }
    
    private func tapRow(at index: Int) {
        
        let sessionStandingsVM: SessionStandingsListViewModel = .init(event: events[index])
        
        route.append(.sessionStandings(sessionStandingsVM))
    }
    
    private func updateTodayEvent(livePositions: [LivePosition] = [], timeInterval: TimeInterval) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { [weak self] _ in
            
            guard let self else { return }
            
            if timeInterval > 0 {
                self.eventService.action.send(.updateAll)
            } else {
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
        case filterEvent(UpcomingOrPastFilter)
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
            .live(LiveCardCellViewModel.mockLiveSoonHours, index: nil),
            .upcomingAndStandings(
                .init(
                    upcoming: GrandPrixCardViewModel.mockArray,
                    drivers: Driver.mockArray,
                    constructors: Constructor.mockArray
                )
            )
        ]
        
        case live(LiveCardCellViewModel, index: Int?)
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
    
    enum UpcomingOrPastFilter: CaseIterable, Hashable, Identifiable {
        
        case upcoming
        case past
        
        var label: String {
            switch self {
            case .upcoming: return "Upcoming"
            case .past: return "Past"
            }
        }
        
        var id: Self { return self }
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
