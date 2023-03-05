import Foundation
import Combine
import OSLog

protocol DriverAndConstructorServiceRepresentable {
    
    var statePublisher: Published<DriverAndConstructorService.State>.Publisher { get }
    var action: PassthroughSubject<DriverAndConstructorService.Action, Never> { get }
}

class DriverAndConstructorService: DriverAndConstructorServiceRepresentable {
    
    var statePublisher: Published<State>.Publisher { $state }
    @Published private var state: State = .refreshing
    
    var action = PassthroughSubject<Action, Never>()
    
    private let networkManager: NetworkManagerRepresentable
    private var subscriptions = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerRepresentable) {
        
        self.networkManager = networkManager
        
        setupBindings()
    }
    
    // Private
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
                        break
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    private func fetchAll() async {
        
        do {
            let drivers = try await networkManager.load(Driver.getDrivers())
            Logger.driverAndConstructorService.info("Fetched \(drivers.count) drivers")
            let constructors = try await networkManager.load(Constructor.getConstructors())
            Logger.driverAndConstructorService.info("Fetched \(constructors.count) constructors")
            state = .refreshed(drivers, constructors)
            
        } catch {
            Logger.driverAndConstructorService.error("Fetch all drivers failed with \(error)")
            state = .error(error)
        }
    }
}


extension DriverAndConstructorService {
    
    enum Action {
        
        case fetchAll
    }
    
    enum State {
        
        case refreshing
        case refreshed([Driver], [Constructor])
        case error(Error)
    }
}


extension DriverAndConstructorService {
    
    static func make() -> DriverAndConstructorService {
        
        .init(networkManager: NetworkManager.shared)
    }
}
