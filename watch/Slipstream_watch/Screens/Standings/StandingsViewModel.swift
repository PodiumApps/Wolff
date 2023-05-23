import Foundation

protocol StandingsViewModelRepresentable: ObservableObject {

    var state: StandingsViewModel.State { get }
    var route: [StandingsNavigation.Route] { get set }
    var selection: StandingsViewModel.Selection { get set }
}

final class StandingsViewModel: StandingsViewModelRepresentable {

    private var navigation: StandingsNavigation
    private var constructors: [Constructor]
    private var drivers: [Driver]

    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable

    @Published var state: StandingsViewModel.State
    @Published var route: [StandingsNavigation.Route]
    @Published var selection: Selection

    init(navigation: StandingsNavigation, driverAndConstructorService: DriverAndConstructorServiceRepresentable) {

        self.navigation = navigation
        self.selection = .drivers
        self.state = .loading
        self.route = []

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

                    return .results
                }
            }
            .assign(to: &$state)
    }
}

extension StandingsViewModel {

    enum State: Equatable {

        case loading
        case error(String)
        case results

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

    enum Selection: String, Identifiable, CaseIterable {

        case drivers
        case constructors

        static var allCases: [Self] {
            return [.drivers, .constructors]
        }

        var id: String {
            switch self {
            case .drivers: return "Drivers"
            case .constructors: return "Constructors"
            }
        }
    }
}

extension StandingsViewModel {

    static func make() -> StandingsViewModel {

        .init(
            navigation: StandingsNavigation(),
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService
        )
    }
}
