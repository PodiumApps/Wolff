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

                Task {
                    switch action {
                    case .fetchAll:
                        self.state = .refreshing
                        await self.fetchAll()
                    case .updateAll:
                        await self.fetchAll()
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    
    private func fetchAll() async {
        
        do {
            let events = try await self.networkManager.load(Event.getEvents())
            Logger.eventService.info("Got \(events.count) events")
            
            state = .refreshed(events)
        } catch {
            Logger.eventService.error("Error \(error)")
            state = .error(error)
        }
    }    
}

extension EventService {
    
    enum Action {
        
        case fetchAll
        case updateAll
    }
    
    enum State {
        
        case refreshing
        case refreshed([Event])
        case error(Error)
    }
}

extension EventService {
    
    static func make() -> EventService {
        
        .init(networkManager: NetworkManager.shared)
    }
}
