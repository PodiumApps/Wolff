import Foundation

protocol StandingsViewModelRepresentable: ObservableObject {

    var state: StandingsViewModel.State { get }
    var selection: StandingsViewModel.Selection { get set }
}

final class StandingsViewModel: StandingsViewModelRepresentable {

    private var constructors: [Constructor]
    private var drivers: [Driver]

    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable

    @Published var state: StandingsViewModel.State
    @Published var selection: StandingsViewModel.Selection

    init(driverAndConstructorService: DriverAndConstructorServiceRepresentable) {

        self.selection = .drivers
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

                    let driverCells: [DriverStandingsCellViewModel] = drivers.enumerated().compactMap { index, driver in

                        guard let constructor = constructors.first(where: { $0.id == driver.constructorId}) else {
                            return nil
                        }

                        return DriverStandingsCellViewModel(
                            driver: driver,
                            constructor: constructor,
                            position: index + 1
                        )
                    }

                    let constructorCells: [ConstructorStandingsCellViewModel] = constructors.enumerated()
                        .compactMap { index, constructor in

                            return ConstructorStandingsCellViewModel(constructor: constructor, position: index + 1)
                        }

                    return .results(driverCells, constructorCells)
                }
            }
            .assign(to: &$state)
    }
}

extension StandingsViewModel {

    enum State: Equatable {

        case loading
        case error(String)
        case results([DriverStandingsCellViewModel], [ConstructorStandingsCellViewModel])

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

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }

    enum Selection: String, Identifiable, CaseIterable {

        case drivers
        case constructors

        var id: Selection { return self }
    }
}

extension StandingsViewModel {

    static func make() -> StandingsViewModel {

        .init(driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService)
    }
}
