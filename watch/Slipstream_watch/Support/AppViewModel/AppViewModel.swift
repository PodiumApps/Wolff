import Foundation
import Combine

protocol AppViewModelRepresentable: ObservableObject {

    var state: AppViewModel.State { get }
    var route: [AppNavigation.Route] { get set }
    
    var presentPremiumSheet: Bool { get set }
}

final class AppViewModel: AppViewModelRepresentable {

    @Published var state: State = .loading
    @Published var route: [AppNavigation.Route] {
        didSet {
            // ⚒️ Means we are going back to the previous navigation and
            // so we need to say something to our Coordinator
            if oldValue.count > route.count {
                navigation.action.send(.update(routes: route))
            }
        }
    }
    @Published var presentPremiumSheet: Bool = false {
        didSet {
            if oldValue {
                purchaseService.action.send(.dismissed)
            }
        }
    }

    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let purchaseService: PurchaseServiceRepresentable
    private let navigation: AppNavigationRepresentable
    
    private var subscriptions = Set<AnyCancellable>()

    init(
        navigation: AppNavigationRepresentable,
        driverAndConstructorService: DriverAndConstructorServiceRepresentable,
        purchaseService: PurchaseServiceRepresentable
    ) {

        self.driverAndConstructorService = driverAndConstructorService
        self.purchaseService = purchaseService
        self.navigation = navigation
        self.route = []

        load()
    }

    // MARK: - Private
    private func load() {

        driverAndConstructorService.action.send(.fetchAll)

        let seasonListViewModel = SeasonListViewModel.make(navigation: navigation)
        let standingsViewModel = StandingsViewModel.make()
        let newsListViewModel = NewsListViewModel.make(navigation: navigation)

        state = .results(seasonListViewModel, standingsViewModel, newsListViewModel)
        
        setupBindings()
    }
    
    private func setupBindings() {
        
        navigation
            .statePublisher
            .receive(on: DispatchQueue.main)
            .map { [weak self] state in

                guard let self else { return [] }
                
                switch state {
                case .started:
                    return []
                case .update(let routes, let containsPremium):
                    if containsPremium {
                        purchaseService.action.send(.checkPremium)
                    }
                    return routes
                }
            }
            .assign(to: &$route)
        
        purchaseService
            .statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] state in
                
                guard let self else { return nil }
                
                switch state {
                case .refreshing:
                    return nil
                case .error:
                    return nil
                case .refreshed(let isPremium, let showSheet):
                    return !isPremium && showSheet
                case .dismissed:
                    navigation.action.send(.removeLast)
                    return nil
                }
            }
            .assign(to: &$presentPremiumSheet)
    }
}

extension AppViewModel {

    enum State {

        case loading
        case error(String)
        case results(SeasonListViewModel, StandingsViewModel, NewsListViewModel)
    }
}

extension AppViewModel {

    static func make() -> AppViewModel {

        .init(
            navigation: AppNavigation(),
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService,
            purchaseService: ServiceLocator.shared.purchaseService
        )
    }
}
