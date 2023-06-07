import Foundation
import Combine

protocol AppNavigationRepresentable {
    
    var statePublisher: Published<AppNavigation.State>.Publisher { get }
    var action: PassthroughSubject<AppNavigation.Action, Never> { get }
}


class AppNavigation: AppNavigationRepresentable {
    
    var statePublisher: Published<AppNavigation.State>.Publisher { $state }
    @Published private var state: AppNavigation.State = .started
    private var route: [AppNavigation.Route] = []
    
    var action = PassthroughSubject<Action, Never>()
    
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
                    return .update(routes: route, containsPremium: checkForPremiumRoute())
                case .remove(let newRoute):
                    route.removeAll(where: { $0 == newRoute } )
                    return .update(routes: route, containsPremium: checkForPremiumRoute())
                case .removeLast:
                    route.removeLast()
                    return .update(routes: route, containsPremium: checkForPremiumRoute())
                case .update(let newRoutes):
                    route = newRoutes
                    return nil
                }
            }
            .assign(to: &$state)
    }
    
    private func checkForPremiumRoute() -> Bool {
        
        return route.contains(where: { $0.id == .sessionStandingsList })
    }
}

extension AppNavigation {
    
    enum Action {
        
        case append(route: Route)
        case remove(route: Route)
        case removeLast
        case update(routes: [Route])
    }
    
    
    enum State {
        
        case started
        case update(routes: [Route], containsPremium: Bool)
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
