import Foundation
import Combine

protocol AppNavigationRepresentable {
    
    var routePublisher: Published<[AppNavigation.Route]>.Publisher { get }
    var action: PassthroughSubject<AppNavigation.Action, Never> { get }
}


class AppNavigation: AppNavigationRepresentable {
    
    var routePublisher: Published<[AppNavigation.Route]>.Publisher { $route }
    @Published private var route: [AppNavigation.Route] = []
    
    var action = PassthroughSubject<Action, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        
        setupBindings()
    }
    
    // MARK: - Private
    private func setupBindings() {
        
        action
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] action in
                guard let self else { return nil }
                switch action {
                case .append(let newRoute):
                    route += [newRoute]
                case .remove(let newRoute):
                    route.removeAll(where: { $0 == newRoute } )
                case .removeLast:
                    route.removeLast()
                case .update(let newRoutes):
                    route = newRoutes
                }
                
                return route
            }
            .assign(to: &$route)
    }
}

extension AppNavigation {
    
    enum Action {
        
        case append(route: Route)
        case remove(route: Route)
        case removeLast
        case update(routes: [Route])
    }
    
    enum Route: Hashable {

        case sessionsList(SessionListViewModel)
        case sessionStandingsList(SessionStandingsListViewModel)
        
        enum Identifier {
            
            case sessionsList
            case sessionStandingsList
        }

        var id: Identifier {
            switch self {
            case .sessionsList: return .sessionsList
            case .sessionStandingsList: return .sessionStandingsList
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
