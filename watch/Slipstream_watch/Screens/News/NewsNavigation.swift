import Foundation
import Combine

protocol NewsNavigationRepresentable: ObservableObject {

    var routePublisher: Published<NewsNavigation.Route?>.Publisher { get }
    var action: PassthroughSubject<NewsNavigation.Action, Never> { get }
}

class NewsNavigation: NewsNavigationRepresentable {

    @Published private var route: Route? = nil
    var routePublisher: Published<Route?>.Publisher { $route }

    var action = PassthroughSubject<Action, Never>()

    private var subscriptions = Set<AnyCancellable>()

    init() {

        self.setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }
                switch action {
                case .goTo(let route):
                    self.route = route
                }
            }
            .store(in: &subscriptions)
    }
}

extension NewsNavigation {

    enum Action {

        case goTo(route: Route?)
    }

    enum Route: Hashable {

        case newsDetails

        var id: String {
            switch self {
            case .newsDetails: return "newsDetails"
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
