import Combine
import Foundation
import OSLog

protocol LiveSessionServiceRepresentable {
    
    var statePublisher: Published<LiveSessionService.State>.Publisher { get }
    var action: PassthroughSubject<LiveSessionService.Action, Never> { get }
}

class LiveSessionService: LiveSessionServiceRepresentable {
    
    private let networkManager: NetworkManager
    private var subscriptions = Set<AnyCancellable>()
    
    var statePublisher: Published<State>.Publisher { $state }
    @Published private var state: State = .refreshing
    
    var action = PassthroughSubject<Action, Never>()
    
    init(networkManager: NetworkManager) {
        
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
                    case .fetchPositions:
                        self.state = .refreshing
                        await self.fetchPositions()
                    case .updatePositions:
                        await self.fetchPositions()
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    private func fetchPositions() async {
        
        do {
            let positions = try await networkManager.load(LivePosition.getLivePositions())
            Logger.liveSessionService.info("Fetch \(positions.count) positions")
            state = .refreshed(positions)
        } catch {
            Logger.liveSessionService.error("Fetch failed with \(error)")
            state = .error(error)
        }
    }
}

extension LiveSessionService {
    
    enum Action {
        
        case fetchPositions
        case updatePositions
    }
    
    enum State {
        
        case refreshing
        case refreshed([LivePosition])
        case error(Error)
    }
    
    
}

extension LiveSessionService {
    
    static func make() -> LiveSessionService {
        
        .init(networkManager: NetworkManager.shared)
    }
}
