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
    private var subscriptions = Set<AnyCancellable>()
    private var timer: Timer? = nil
    
    @Published var state: State
    @Published var route: [Route]
    var action = PassthroughSubject<Action, Never>()
    
    init(
        driverAndConstructorService: DriverAndConstructorServiceRepresentable,
        eventService: EventServiceRepresentable
    ) {
        
        self.drivers = []
        self.events = []
        self.eventService = eventService
        self.driverAndConstructorService = driverAndConstructorService
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

        Publishers
            .Zip(driverAndConstructorService.statePublisher, eventService.statePublisher)
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] driverAndConstructorService, eventService in

                guard let self else { return nil }
                
                switch (driverAndConstructorService, eventService) {
                case (.error(let error), _),
                     (_, .error(let error)):
                    return .error(error.localizedDescription)

                case (.refreshed(let drivers, _), .refreshed(let events, let nextEvent)):
                    self.drivers = drivers
                    self.events = events
                    self.nextEvent = nextEvent
                    return .results(self.buildGranPrixCardViewModel(events: events, nextEvent: nextEvent))

                default:
                    return .loading(self.buildGranPrixCardViewModel(events: Event.mockArray, nextEvent: .mock))
                }
            }
            .assign(to: &$state)
    }
    
    private func buildGranPrixCardViewModel(events: [Event], nextEvent: Event) -> [GrandPrixCardViewModel] {
        
        events.enumerated().compactMap { [weak self] (index, event) in
            
            guard let self else { return nil }
            
            let eventStatus = Event.getEventStatus(for: event, comparing: nextEvent, drivers: self.drivers)
            
            if case .current(_, _, true) = eventStatus {
                self.updateTodayEvent(index: index)
            }
            
            return GrandPrixCardViewModel(
                round: event.round,
                title: event.name,
                eventStatus: eventStatus
            )
        }
    }
    
    private func tapRow(at index: Int) {
        
        let sessionStandingsVM: SessionStandingsListViewModel = .init(event: events[index])
        
        route.append(.sessionStandings(sessionStandingsVM))
    }
    
    private func updateTodayEvent(index: Int) {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            
            guard
                let self,
                let nextEvent = self.nextEvent,
                case .results(var granPrixVM) = self.state
            else {
                return
            }
            
            debugPrint("Updating event index \(index)")
            granPrixVM[index].eventStatus = Event.getEventStatus(
                for: self.events[index],
                comparing: nextEvent,
                drivers: self.drivers
            )
            
            self.state = .results(granPrixVM)
        }
    }
}

extension SeasonListViewModel {
    
    enum State: Equatable {
        
        static func == (lhs: SeasonListViewModel.State, rhs: SeasonListViewModel.State) -> Bool {
            lhs.id == rhs.id
        }
        
        case error(String)
        case results([GrandPrixCardViewModel])
        case loading([GrandPrixCardViewModel])
        
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
}

extension SeasonListViewModel {
    
    static func make() -> SeasonListViewModel {
        
        .init(
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService,
            eventService: ServiceLocator.shared.eventService
        )
    }
}
