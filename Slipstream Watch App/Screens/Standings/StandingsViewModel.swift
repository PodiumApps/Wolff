import Foundation
import Combine

protocol StandingsViewModelRepresentable: ObservableObject {

    var state: StandingsViewModel.State { get }
    var selection: StandingsViewModel.Selection { get set }
}

final class StandingsViewModel: StandingsViewModelRepresentable {

    private var constructors: [Constructor]
    private var drivers: [Driver]

    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let navigation: AppNavigationRepresentable

    private var subscribers = Set<AnyCancellable>()

    @Published var state: StandingsViewModel.State
    @Published var selection: StandingsViewModel.Selection

    init(
        navigation: AppNavigationRepresentable,
        driverAndConstructorService: DriverAndConstructorServiceRepresentable
    ) {

        self.navigation = navigation
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
                case .error:
                    return nil
                case .refreshing:
                    return .loading
                case .refreshed(let drivers, let constructors):

                    self.drivers = drivers
                    self.constructors = constructors

                    let driverCells = buildDriverCells()
                    let constructorCells = buildConstructorCells()
                    
                    return .results(driverCells, constructorCells)
                }
            }
            .assign(to: &$state)
    }
    
    private func buildDriverCells() -> [DriverStandingsCellViewModel] {
        
        return drivers.enumerated().compactMap { [weak self] index, driver in

            guard let self, let constructor = constructors.first(where: { $0.id == driver.constructorId}) else {
                return nil
            }
            
            let viewModel = DriverStandingsCellViewModel(
                driver: driver,
                constructor: constructor,
                position: index + 1
            )
            
            viewModel.action
                .receive(on: DispatchQueue.main)
                .sink { [weak self] action in
                    guard let self else { return }
                    
                    let driverDetailsViewModel = DriverStandingsDetailsViewModel.make(
                        driverName: "\(viewModel.firstName) \(viewModel.lastName)",
                        driverID: viewModel.driverID,
                        constructorID: viewModel.constructor.id
                    )

                    switch action {
                    case .openDetailsView:
                        navigation.action.send(.append(route: .driverStandingDetails(driverDetailsViewModel)))
                    }
                }
                .store(in: &subscribers)

            return viewModel
        }
    }
    
    private func buildConstructorCells() -> [ConstructorStandingsCellViewModel] {
        
        constructors.enumerated()
            .compactMap { index, constructor in
                
                let viewModel: ConstructorStandingsCellViewModel = .init(constructor: constructor, position: index + 1)
                
                viewModel.action
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] action in
                        guard let self else { return }
                        
                        let constructorDriverDetailsViewModel: ConstructorStandingsDetailsViewModel =
                            .make(constructorID: viewModel.constructorID, constructorName: viewModel.name)

                        switch action {
                        case .openDetailsView:
                            navigation.action.send(.append(
                                route: .constructorStandingDetails(constructorDriverDetailsViewModel))
                            )
                        }
                    }
                    .store(in: &subscribers)

                return viewModel
            }

    }
}

extension StandingsViewModel {

    enum State: Equatable {

        case loading
        case results([DriverStandingsCellViewModel], [ConstructorStandingsCellViewModel])

        enum Identifier: String {

            case loading
            case error
            case results
        }

        var id: Identifier {

            switch self {
            case .loading: return .loading
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

    static func make(navigation: AppNavigationRepresentable) -> StandingsViewModel {

        .init(
            navigation: navigation,
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService
        )
    }
}
