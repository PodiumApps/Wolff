import Foundation

protocol AppViewModelRepresentable: ObservableObject {

    var state: AppViewModel.State { get }
    var route: [AppViewModel.Route] { get set }
}

final class AppViewModel: AppViewModelRepresentable {

    @Published var state: State = .loading
    @Published var route: [Route]

    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable

    init(driverAndConstructorService: DriverAndConstructorServiceRepresentable) {

        self.driverAndConstructorService = driverAndConstructorService
        self.route = []

        load()
    }

    private func load() {

        driverAndConstructorService.action.send(.fetchAll)

        let seasonListViewModel = SeasonListViewModel.make()
        let standingsViewModel = StandingsViewModel.make()

        state = .results(seasonListViewModel, standingsViewModel)
    }
}

extension AppViewModel {

    enum State {

        case loading
        case error(String)
        case results(SeasonListViewModel, StandingsViewModel)
    }

    enum Route: Hashable {

        case seasonList(SeasonListViewModel)
        case sessionsList(SessionListViewModel)
        case sessionStandingsList(SessionStandingsListViewModel)

        var id: String {
            switch self {
            case .seasonList: return "seasonList"
            case .sessionsList: return "sessionList"
            case .sessionStandingsList: return "sessionStandingsList"
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}

extension AppViewModel {

    static func make() -> AppViewModel {

        .init(driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService)
    }
}
