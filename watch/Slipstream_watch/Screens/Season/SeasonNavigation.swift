import Foundation
import Combine

protocol SeasonNavigationProtocol: ObservableObject {
    
    var routePublisher: Published<SeasonNavigation.Route?>.Publisher { get }
    var action: PassthroughSubject<SeasonNavigation.Action, Never> { get }
}


class SeasonNavigation: SeasonNavigationProtocol {
    
    var routePublisher: Published<SeasonNavigation.Route?>.Publisher { $route }
    @Published private var route: SeasonNavigation.Route? = nil
    
    var action = PassthroughSubject<Action, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    init() {
        
        setupBindings()
    }
    
    // MARK: - Private
    private func setupBindings() {
        
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }
                switch action {
                case .goTo(let route):
                    self.route = route
                case .removeRout:
                    self.route = nil
                }
            }
            .store(in: &subscriptions)
    }
}

extension SeasonNavigation {
    
    enum Action {
        
        case goTo(route: Route?)
        case removeRout
    }
    
    enum Route: Hashable {

        case sessionsList(SessionListViewModel)
        case sessionStandingsList(SessionStandingsListViewModel)

        var id: String {
            switch self {
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
