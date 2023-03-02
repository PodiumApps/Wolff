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
    
    // Private
    private func load() {
       
        driverAndConstructorService.action.send(.fetchAll)
        
        driverAndConstructorService.statePublisher
            .receive(on: DispatchQueue.main)
            .map { serviceStatus in
                
                switch serviceStatus {
                case .error(let serviceError):
                    switch serviceError {
                    case .fetchDriverFailed(let error), .fetchAllFailed(let error):
                        return .error(error.localizedDescription)
                    }
                    
                case .refreshing:
                    return .loading
                case .refreshed(let drivers, let constructors):
                    let liveSessionViewModel = SessionStandingsListViewModel(
                        drivers: drivers,
                        constructors: constructors
                    )
                    return .results(liveSessionViewModel)
                    
                }
            }
            .assign(to: &$state)
        
    }
    
}

extension AppViewModel {
    
    enum State {
        
        case loading
        case error(String)
        case results(SessionStandingsListViewModel)
    }
}

extension AppViewModel {
    
    static func make() -> AppViewModel {
        
        .init(driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService)
    }
}
