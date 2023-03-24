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
    }
}

extension AppViewModel {

    enum State {

        case loading
        case error(String)
        case results
    }
}

extension AppViewModel {

    static func make() -> AppViewModel {

        .init(driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService)
    }
}
