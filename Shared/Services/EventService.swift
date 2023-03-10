import Combine
import Foundation
import OSLog

protocol EventServiceRepresentable {
    
    var statePublisher: Published<EventService.State>.Publisher { get }
    var action: PassthroughSubject<EventService.Action, Never> { get }
}

class EventService: EventServiceRepresentable {
    
    var statePublisher: Published<EventService.State>.Publisher { $state }
    @Published private var state: State = .refreshing
    
    var action = PassthroughSubject<Action, Never>()
    
    private let networkManager: NetworkManagerRepresentable
    private var subscriptions = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerRepresentable) {
        
        self.networkManager = networkManager
        
        setupBindings()
    }
    
    // MARK: - Private
    private func setupBindings() {
        
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }
                self.state = .refreshing
                Task {
                    switch action {
                    case .fetchAll:
                        await self.fetchAll()
                    }
                }
            }
            .store(in: &subscriptions)
        
    }
    
    
    private func fetchAll() async {
        
        do {
            let events = try await self.networkManager.load(Event.getEvents())
            let nextEvent = try await self.networkManager.load(Event.getNextEvent())
            Logger.liveSessionService.info("Got \(events.count) events and nextEventID = \(nextEvent.id)")
            
            state = .refreshed(events, nextEvent: nextEvent)
        } catch {
            Logger.liveSessionService.error("Error \(error)")
            state = .error(error)
        }
    }
    
}

extension EventService {
    
    enum Action {
        
        case fetchAll
    }
    
    enum State {
        
        case refreshing
        case refreshed([Event], nextEvent: Event)
        case error(Error)
    }
}

extension EventService {
    
    static func make() -> EventService {
        
        .init(networkManager: NetworkManager.shared)
    }
}