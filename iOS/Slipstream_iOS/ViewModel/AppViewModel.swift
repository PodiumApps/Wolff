import SwiftUI
import Combine

protocol AppViewModelRepresentable: ObservableObject {
    
    var state: AppViewModel.State { get }
}

class AppViewModel: AppViewModelRepresentable {
    
    @Published var state: State = .loading
    
    @AppStorage(UserDefaultsKeys.firstTime.rawValue) private var firstTime: Bool = false
    
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let networkManager: NetworkManagerRepresentable
    
    init(
        driverAndConstructorService: DriverAndConstructorServiceRepresentable,
        networkManager: NetworkManagerRepresentable
    ) {
        
        self.driverAndConstructorService = driverAndConstructorService
        self.networkManager = networkManager
        
        load()
    }
    
    // MARK: - Private
    private func load() {
       
        driverAndConstructorService.action.send(.fetchAll)
        let seasonListViewModel = SeasonListViewModel.make()
        state = .results(seasonListViewModel)
        
        Task {
            let _ = try? await networkManager.load(User.createOrUpdate(isPremium: false))
        }
    }
    
}

extension AppViewModel {
    
    enum State {
        
        case loading
        case error(String)
        case results(SeasonListViewModel)
    }
}

extension AppViewModel {
    
    static func make() -> AppViewModel {
        
        .init(
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService,
            networkManager: NetworkManager.shared
        )
    }
}
