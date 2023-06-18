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
                    return .update(routes: route, containsPremium: route.contains(where: \.isPremium))
                case .remove(let newRoute):
                    route.removeAll(where: { $0 == newRoute } )
                    return .update(routes: route, containsPremium: route.contains(where: \.isPremium))
                case .removeLast:
                    route.removeLast()
                    return .update(routes: route, containsPremium: route.contains(where: \.isPremium))
                case .update(let newRoutes):
                    route = newRoutes
                    return nil
                }
            }
            .assign(to: &$state)
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
        case newsDetails(NewsDetailsViewModel)
        case driverStandingDetails(DriverStandingsDetailsViewModel)
        case constructorStandingDetails(ConstructorStandingsDetailsViewModel)
        
        enum Identifier {
            
            case sessionsList
            case sessionStandingsList
            case newsDetails
            case driverStandingDetails
            case constructorStandingDetails
        }

        var id: Identifier {
            switch self {
            case .sessionsList: return .sessionsList
            case .sessionStandingsList: return .sessionStandingsList
            case .newsDetails: return .newsDetails
            case .driverStandingDetails: return .driverStandingDetails
            case .constructorStandingDetails: return .constructorStandingDetails
            }
        }
        
        var isPremium: Bool {
            switch id {
            case .newsDetails,
                 .sessionStandingsList,
                 .driverStandingDetails,
                 .constructorStandingDetails:
                return false
            case .sessionsList:
                return false
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
