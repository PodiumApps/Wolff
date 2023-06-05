import Foundation

protocol AppViewModelRepresentable: ObservableObject {

    var state: AppViewModel.State { get }
    var route: [AppViewModel.Route] { get set }
    
    var presentPremiumSheet: Bool { get set }
}

final class AppViewModel: AppViewModelRepresentable {

    @Published var state: State = .loading
    @Published var route: [Route]
    @Published var presentPremiumSheet: Bool = false {
        didSet {
            if oldValue {
                purchaseService.action.send(.dismissed)
            }
        }
    }

    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let purchaseService: PurchaseServiceRepresentable

    init(
        driverAndConstructorService: DriverAndConstructorServiceRepresentable,
        purchaseService: PurchaseServiceRepresentable
    ) {

        self.driverAndConstructorService = driverAndConstructorService
        self.purchaseService = purchaseService
        self.route = []

        load()
    }

    // MARK: - Private
    private func load() {

        driverAndConstructorService.action.send(.fetchAll)

        let seasonListViewModel = SeasonListViewModel.make()
        let standingsViewModel = StandingsViewModel.make()

        state = .results(seasonListViewModel, standingsViewModel)
        
        setupBindings()
    }
    
    private func setupBindings() {
        
        purchaseService
            .statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { state in
                switch state {
                case .refreshing:
                    return nil
                case .error:
                    return true
                case .refreshed(let isPremium):
                    return !isPremium
                case .dismissed:
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

        .init(
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService,
            purchaseService: ServiceLocator.shared.purchaseService
        )
    }
}
