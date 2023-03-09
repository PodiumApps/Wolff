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
        
        driverAndConstructorService.statePublisher
            .receive(on: DispatchQueue.main)
            .map { serviceStatus in
                
                switch serviceStatus {
                case .error(let error):
                    return .error(error.localizedDescription)
                case .refreshing:
                    return .loading
                case .refreshed(let drivers, let constructors):
                    let seasonListViewModel = SeasonListViewModel(drivers: drivers, constructors: constructors)
                    return .results(seasonListViewModel)
                    
                }
            }
            .assign(to: &$state)
        
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
