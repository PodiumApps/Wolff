import Foundation
import Combine

protocol AppViewModelRepresentable: ObservableObject {

    var state: AppViewModel.State { get }
    var route: [AppNavigation.Route] { get set }
    var action: PassthroughSubject<AppViewModel.Action, Never> { get }
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

    private let eventService: EventServiceRepresentable
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let liveSessionService: LiveSessionServiceRepresentable
    private let newsService: NewsServiceRepresentable
    private let purchaseService: PurchaseServiceRepresentable

    private let navigation: AppNavigationRepresentable

    var action = PassthroughSubject<Action, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(
        navigation: AppNavigationRepresentable,
        eventService: EventServiceRepresentable,
        driverAndConstructorService: DriverAndConstructorServiceRepresentable,
        liveSessionService: LiveSessionServiceRepresentable,
        newsService: NewsServiceRepresentable,
        purchaseService: PurchaseServiceRepresentable
    ) {

        self.eventService = eventService
        self.driverAndConstructorService = driverAndConstructorService
        self.liveSessionService = liveSessionService
        self.newsService = newsService
        self.purchaseService = purchaseService
        self.navigation = navigation
        self.route = []

        load()
    }

    // MARK: - Private
    private func load() {

        driverAndConstructorService.action.send(.fetchAll)

        let seasonListViewModel = SeasonListViewModel.make(navigation: navigation)
        let standingsViewModel = StandingsViewModel.make(navigation: navigation)
        let newsListViewModel = NewsListViewModel.make(navigation: navigation)
        let settingsViewModel = SettingsViewModel.make(navigation: navigation)

        state = .results(seasonListViewModel, standingsViewModel, newsListViewModel, settingsViewModel)
        
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

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }

                switch action {
                case .reloadServices:

                    liveSessionService.action.send(.updatePositions)
                    newsService.action.send(.updateAll)
                }
            }
            .store(in: &subscriptions)
    }
}

extension AppViewModel {

    enum State {

        case loading
        case error(String)
        case results(SeasonListViewModel, StandingsViewModel, NewsListViewModel, SettingsViewModel)
    }

    enum Action {

        case reloadServices
    }
}

extension AppViewModel {

    static func make() -> AppViewModel {

        .init(
            navigation: AppNavigation(),
            eventService: ServiceLocator.shared.eventService,
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService,
            liveSessionService: ServiceLocator.shared.liveSessionService,
            newsService: ServiceLocator.shared.newsService,
            purchaseService: ServiceLocator.shared.purchaseService
        )
    }
}
