import Foundation
import Combine

protocol AppViewModelRepresentable: ObservableObject {
    
    var state: AppViewModel.State { get }
}

class AppViewModel: AppViewModelRepresentable {
    
    @Published var state: State = .loading
    
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    
    init(driverAndConstructorService: DriverAndConstructorServiceRepresentable) {
        
        self.driverAndConstructorService = driverAndConstructorService
        
        load()
    }
    
    // MARK: - Private
    private func load() {
       
        driverAndConstructorService.action.send(.fetchAll)
        let seasonListViewModel = SeasonListViewModel.make()
        state = .results(seasonListViewModel)
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
        
        .init(driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService)
    }
}
