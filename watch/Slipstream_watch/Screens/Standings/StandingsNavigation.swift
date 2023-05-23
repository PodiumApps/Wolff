import Foundation
import Combine

protocol StandingsNavigationProtocol: ObservableObject {

    var routePublisher: Published<StandingsNavigation.Route?>.Publisher { get }
    var action: PassthroughSubject<StandingsNavigation.Action, Never> { get }
}

final class StandingsNavigation: StandingsNavigationProtocol {

    @Published private var route: StandingsNavigation.Route? = nil
    var routePublisher: Published<StandingsNavigation.Route?>.Publisher { $route }

    var action = PassthroughSubject<Action, Never>()

    private var subscriptions = Set<AnyCancellable>()

    init() {

        self.setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink {  [weak self] action in
                guard let self else { return }
                switch action {
                case .goTo(let route):
                    self.route = route
                }
            }
            .store(in: &subscriptions)
    }
}

extension StandingsNavigation {

    enum Action {

        case goTo(route: Route?)
    }

    enum Route: Hashable {

        case driversStandingsListView
        case driverDetailsView
        case constructorsStandingsListView
        case constructorsDetailsView

        var id: String {
            switch self {
            case .driversStandingsListView: return "driverStandingsListView"
            case .driverDetailsView: return "driverDetailsView"
            case .constructorsStandingsListView: return "constructorStandingsListView"
            case .constructorsDetailsView: return "constructorDetailsView"
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
