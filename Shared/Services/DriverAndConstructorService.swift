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
    
    @UserDefaultsWrapper(key: .drivers)
    private var persistedDrivers: [Driver]?
    
    @UserDefaultsWrapper(key: .constructors)
    private var persistedConstructors: [Constructor]?
    
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
        
        if let drivers = persistedDrivers,
           !drivers.isEmpty,
           let constructors = persistedConstructors,
           !constructors.isEmpty
        {
            state = .refreshed(drivers, constructors)
            Logger.driverAndConstructorService
                .info("\(drivers.count) drivers and \(constructors.count) constructors from persistence")
        }
        
        do {
            async let drivers = networkManager.load(Driver.getDrivers())
            self.persistedDrivers = try await drivers
            Logger.driverAndConstructorService.info("Fetched \(self.persistedDrivers?.count ?? 0) drivers")
            
            async let constructors = networkManager.load(Constructor.getConstructors())
            self.persistedConstructors = try await constructors
            Logger.driverAndConstructorService.info("Fetched \(self.persistedConstructors?.count ?? 0) constructors")
            
            state = try await .refreshed(drivers, constructors)
        } catch {
            Logger.driverAndConstructorService.error("Fetch all drivers failed with \(error)")
            state = .error(error)
        }
    }
}


extension DriverAndConstructorService {
    
    enum Action {
        
        case fetchAll
        case updateAll
    }
    
    enum State {
        
        case refreshing
        case refreshed([Driver], [Constructor])
        case error(Error)
    }
    
    enum RefreshStatus {
        
        case defaults
        case server
    }
}

extension DriverAndConstructorService {
    
    static func make() -> DriverAndConstructorService {
        
        .init(networkManager: NetworkManager.shared)
    }
}
