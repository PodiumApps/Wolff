import Combine
import Foundation

protocol SeasonListViewModelRepresentable: ObservableObject {
    
    var state: SeasonListViewModel.State { get }
    var route: [SeasonListViewModel.Route] { get set }
    var action: PassthroughSubject<SeasonListViewModel.Action, Never> { get }
}

class SeasonListViewModel: SeasonListViewModelRepresentable {
    
    private var drivers: [Driver]
    private var events: [Event]
    private var nextEvent: Event?
    private let eventService: EventServiceRepresentable
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let liveEventService: LiveSessionServiceRepresentable
    private var subscriptions = Set<AnyCancellable>()
    private var timer: Timer? = nil
    private var updatedIndex: Int? = nil
    
    @Published var cells: [Cell] = []
    
    @Published var state: State
    @Published var route: [Route]
    var action = PassthroughSubject<Action, Never>()
    
    init(
        driverAndConstructorService: DriverAndConstructorServiceRepresentable,
        eventService: EventServiceRepresentable,
        liveEventService: LiveSessionServiceRepresentable
    ) {
        
        self.drivers = []
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
                switch action {
                case .tap(let index):
                    self?.tapRow(at: index)
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
                    if let index = self.cells.firstIndex(where: { $0.id == Cell.idValue.live.rawValue }) {
                        
                        self.cells[index] = .live(LiveViewModel.mockLiveSoonHours, index: nil)
                                                  
                        self.state = .results(self.cells)
                    }
                }
                
            }
            .store(in: &subscriptions)
        
       eventService.statePublisher
            .combineLatest(driverAndConstructorService.statePublisher)
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] eventService, driverAndConstructorService in

                guard let self else { return nil }
                
                switch (eventService, driverAndConstructorService) {
                case (.error(let error), _), (_, .error(let error)):
                    return .error(error.localizedDescription)

                case (.refreshed(let events, let nextEvent), .refreshed(let drivers, _)):
                    self.drivers = drivers
                    self.events = events
                    self.nextEvent = nextEvent
                    return self.loadData(fetchLivePositions: self.cells.isEmpty)

                case (.refreshing, _), (_, .refreshing):
                    return self.cells.isEmpty ? .loading(Cell.cellsLoading) : .results(self.cells)
                }
            }
            .assign(to: &$state)
    }
    
    private func loadData(
        livePositions: [LivePosition] = [],
        fetchLivePositions: Bool
    ) -> State {
        
        cells = []
        
        guard let nextEvent else { return .error("No next event") }
        
        if fetchLivePositions { liveEventService.action.send(.fetchPositions) }
        
        var upcomingEvents: [GrandPrixCardViewModel] = []
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
                    cells.append(.live(LiveViewModel.mockLiveSoon, index: nil))
                } else {
                    cells.append(
                        .live(
                            .init(
                                topSection: LiveViewModel.TopSection(title: event.name, round: event.round),
                                cardSection: LiveViewModel.CardSection(
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
            
            if case .upcoming(let start, let end, let session) = eventStatus {
                
                upcomingEvents.append(
                    .init(
                        round: event.round,
                        title: event.name,
                        subtitle: "Italy",
                        grandPrixDate: start + " - " + end,
                        isNext: session != nil
                    )
                )
                
            }
        }
        
        cells.append(.upcoming(upcomingEvents))
        cells.append(.pastEvent)
        
        return .results(cells)
    }
    
    private func tapRow(at index: Int) {
        
        let sessionStandingsVM: SessionStandingsListViewModel = .init(event: events[index])
        
        route.append(.sessionStandings(sessionStandingsVM))
    }
    
    private func updateTodayEvent(livePositions: [LivePosition] = [], timeInterval: TimeInterval) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: livePositions.isEmpty) { [weak self] _ in
            
            guard let self else { return }
            
            if timeInterval <= 0 {
                self.liveEventService.action.send(.updatePositions)
            } else {
                self.eventService.action.send(.updateAll)
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
        case results([Cell])
        case loading([Cell])
        
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
    
    enum Cell: Equatable, Identifiable {
        
        static func == (lhs: SeasonListViewModel.Cell, rhs: SeasonListViewModel.Cell) -> Bool {
            lhs.id == rhs.id
        }
        
        static let cellsLoading: [Self] = [
            .live(LiveViewModel.mockLiveSoonHours, index: nil),
            .upcoming(GrandPrixCardViewModel.mockArray)
        ]
        
        case live(LiveViewModel, index: Int?)
        case upcoming([GrandPrixCardViewModel])
        case pastEvent
        
        enum idValue: String {
            case live = "live"
            case upcoming = "upcoming"
            case pastEvent = "pastEvent"
        }
        
        var id: String {
            
            switch self {
            case .live: return idValue.live.rawValue
            case .upcoming: return idValue.upcoming.rawValue
            case .pastEvent: return idValue.pastEvent.rawValue
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
