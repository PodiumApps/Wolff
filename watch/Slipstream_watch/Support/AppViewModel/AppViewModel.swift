import Foundation

protocol AppViewModelRepresentable: ObservableObject {

    var state: AppViewModel.State { get }
}

final class AppViewModel: AppViewModelRepresentable {

    @Published var state: State = .loading

    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable

    init(driverAndConstructorService: DriverAndConstructorServiceRepresentable) {

        self.driverAndConstructorService = driverAndConstructorService

        load()
    }

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
