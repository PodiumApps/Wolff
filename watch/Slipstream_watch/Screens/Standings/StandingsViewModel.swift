import Foundation

protocol StandingsViewModelRepresentable: ObservableObject {

    var state: StandingsViewModel.State { get }
}

final class StandingsViewModel: StandingsViewModelRepresentable {

    private var constructors: [Constructor]
    private var drivers: [Driver]

    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable

    @Published var state: StandingsViewModel.State

    init(driverAndConstructorService: DriverAndConstructorServiceRepresentable) {

        self.state = .loading

        self.drivers = []
        self.constructors = []
        self.driverAndConstructorService = driverAndConstructorService

        self.setUpServices()
    }

    private func setUpServices() {

        driverAndConstructorService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] driverAndConstructorService -> StandingsViewModel.State? in
                
                guard let self else { return nil }

                switch driverAndConstructorService {
                case .error(let error):
                    return .error(error.localizedDescription)
                case .refreshing:
                    return .loading
                case .refreshed(let drivers, let constructors):

                    self.drivers = drivers
                    self.constructors = constructors

                    return self.buildStandingsCells()
                }
            }
            .assign(to: &$state)
    }

    private func buildStandingsCells() -> StandingsViewModel.State {

        return .results([])
    }
}

extension StandingsViewModel {

    enum State: Equatable {

        case loading
        case error(String)
        case results([Cell])

        enum Identifier: String {

            case loading
            case error
            case results
        }

        var id: Identifier {

            switch self {
            case .loading: return .loading
            case .error: return .error
            case .results: return .results
            }
        }
    }

    enum Cell: Equatable, Identifiable {

        case driver
        case constructor

//        case driver(DriverStandingsCellViewModel)
//        case constructor(ConstructorStandingsCellViewModel)

        enum Identifer: String {

            case driver
            case constructor
        }

        var id: Identifer {

            switch self {
            case .driver: return .driver
            case .constructor: return .constructor
            }
        }
    }
}
