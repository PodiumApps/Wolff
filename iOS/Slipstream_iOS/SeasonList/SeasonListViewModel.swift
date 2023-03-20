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
        self.state = .loading(Section.cellsLoading)
        self.route = []
        self.nextEvent = nil
        
        load()
    }
    
    // MARK: - Private
    private func load() {
        
        eventService.action.send(.fetchAll)
        
        liveEventService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] liveEventService in
                
                guard
                    let self,
                    case .results(var cells) = self.state,
                    let index = cells.firstIndex(where: { $0.id == .live })
                else {
                    return nil
                }
                
                switch liveEventService {
                case .refreshed(let livePositions):
                    
                    return .results(self.loadLiveData(livePositions: livePositions))
                    
                case .refreshing, .error:
                    cells[index] = .live(LiveCardCellViewModel.mockLiveAboutToStart, isLoading: true)
                    return .results(cells)
                }
                
                
            }
            .assign(to: &$state)
        
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
                    return .results(self.loadData())

                case (.refreshing, _), (_, .refreshing):
                    return .loading(Section.cellsLoading)
                }
            }
            .assign(to: &$state)
    }
    
    private func loadData() -> [Section] {
        
        if firstReload {
            liveEventService.action.send(.fetchPositions)
            firstReload = false
        }
        
        switch state {
        case .loading(var cells), .results(var cells):
            
            let upcomingEvents: [Event.ShortDetails] = events.lazy.compactMap { event in
                
                guard event.status.id != .live else { return nil }
                
                return .init(
                    status: event.status,
                    round: event.round,
                    title: event.title,
                    country: event.country
                )
            }
            
            timerEvents?.invalidate()
            updateEvents()
            
            if !events.contains(where: { $0.status.id == .live }) {
                cells = [.upcomingAndStandings(buildUpcomingAndStandingsViewModel(with: upcomingEvents))]
            } else if let cellIndex = cells.firstIndex(where: { $0.id == .upcomingAndStandings }) {
                cells[cellIndex] = .upcomingAndStandings(buildUpcomingAndStandingsViewModel(with: upcomingEvents))
            }
            
            return cells
        case.error:
            return []
        }
    }
    
    private func loadLiveData(livePositions: [LivePosition] = []) -> [Section] {
        
        switch state {
        case .loading(var cells), .results(var cells):
            
            guard
                let index = cells.firstIndex(where: { $0.id == .live }),
                let nextLiveEventIndex = events
                    .firstIndex(where: { $0.status.id == .live }),
                case .live(let timeInterval, _) = self.events[nextLiveEventIndex].status
            else {
                 return []
            }
            
            timer?.invalidate()
            
            updateTodayEvent(timeInterval: timeInterval)
            
            if timeInterval < -.hourInterval && livePositions.isEmpty {
                timerEvents?.invalidate()
                updateEvents(force: true)
                cells.remove(at: index)
            } else {
                cells[index] = .live(
                    buildLiveViewModel(
                        with: events[nextLiveEventIndex].shortDetails,
                        index: index,
                        livePositions: livePositions
                    )
                )
            }
            
            return cells
        case.error:
            return []
        }
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
            withTimeInterval: timeInterval > 0 && timeInterval < .hourInterval && livePositions.isEmpty ? 1 : 60,
            repeats: false
        ) { [weak self] _ in
            
            guard let self else { return }
            
            if timeInterval <= 0 {
                self.liveEventService.action.send(.updatePositions)
            } else {
                self.state = .results(self.loadLiveData())
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
                self.state = .results(self.loadData())
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
        
        enum Identifier: String {
            
            case error
            case loading
            case results
        }
        
        var id: Identifier {
            
            switch self {
            case .loading: return .loading
            case .results: return .results
            case .error: return .error
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
        
        enum Identifier {
            case live
            case upcomingAndStandings
        }
        
        var id: Identifier {
            
            switch self {
            case .live: return .live
            case .upcomingAndStandings: return .upcomingAndStandings
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
