import Combine
import OSLog
import StoreKit

protocol PurchaseServiceRepresentable {

    var action: PassthroughSubject<PurchaseService.Action, Never> { get }
    var statePublisher: Published<PurchaseService.State>.Publisher { get }
}

class PurchaseService: PurchaseServiceRepresentable {

    @UserDefaultsWrapper(key: .user)
    private var persistedUserId: String?

    private var isPremium: Bool = false

    private var products: [Product] = []
    private var purchasedProducts: Set<Product> = [] {
        didSet {
            if !purchasedProducts.isEmpty {
                self.isPremium = true
            } else {
                self.isPremium = false
            }
        }
    }

    private let productIDs: [String] = [
        "com.tomasmamede.SlipstreamWatch.subscription_monthly",
        "com.tomasmamede.SlipstreamWatch.subscription_annually"
    ]

    var action: PassthroughSubject<Action, Never> = .init()
    var subscribers: Set<AnyCancellable> = .init()

    @Published private var state: State = .refreshing
    var statePublisher: Published<State>.Publisher { $state }

    private let networkManager: NetworkManagerRepresentable

    init(networkManager: NetworkManagerRepresentable) {

        self.networkManager = networkManager

        Task { await self.registerUser() }
        self.setUpBindings()
    }

    private func registerUser() async {

        if persistedUserId == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: UserDefaultsKeys.user.rawValue)
        }

        do {
            let user = try await networkManager.load(User.createOrUpdate(isPremium: isPremium))
            Logger.userService.info("\(user.id.string) with premium \(self.isPremium) successfully updated")
        } catch {
            Logger.userService.error("Something went wrong when creating this user")
        }
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }

                switch action {
                case .loadProducts:
                    Task { [weak self] in

                        guard let self else { return }

                        await self.loadProducts()
                    }
                case .purchase(let productID):
                    Task { [weak self] in

                        guard let self else { return }

                        guard let product = products.first(where: { $0.id == productID }) else { return }
                        try await self.purchase(product: product)

                        state = .refreshed(isPremium: isPremium, products: products, showSheet: false)
                    }
                case .restorePurchase:
                    Task { [weak self] in

                        guard let self else { return }

                        await self.refreshPurchasedProducts()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.state = .refreshed(isPremium: self.isPremium, products: self.products, showSheet: true)
                        }
                    }
                case .checkPremium:
                    state = .refreshing
                    self.action.send(.restorePurchase)
                case .dismiss:
                    state = .dismissed
                    state = .refreshed(isPremium: isPremium, products: products, showSheet: false)
                }
            }
            .store(in: &subscribers)

    }

    @MainActor private func loadProducts() async {

        do {

            self.products = try await Product.products(for: productIDs)
            state = .refreshed(isPremium: isPremium, products: products, showSheet: false)
        } catch {

            self.state = .error(Localization.ErrorScreen.Subscriptions.label)
        }
    }

    private func purchase(product: Product) async throws -> Transaction? {

        let purchaseResult = try await product.purchase()

        switch purchaseResult {
        case .success(let result):

            let transaction = try checkTransactionVerification(result: result)

            await self.refreshPurchasedProducts()
            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            action.send(.dismiss)
            return nil
        @unknown default:
            action.send(.dismiss)
            return nil
        }
    }

    private func checkTransactionVerification<T>(result: VerificationResult<T>) throws -> T {

        switch result {
        case .verified(let transaction):
            return transaction
        case .unverified:
            throw StoreKitError.unknown
        }
    }

    @MainActor private func refreshPurchasedProducts() async {

        for await verificationResult in Transaction.currentEntitlements {

            switch verificationResult {
            case .verified(let transaction):
                if let validProduct = products.first(where: { $0.id == transaction.productID }) {
                    purchasedProducts.insert(validProduct)
                }
            case .unverified(_, _):
                return
            }
        }
    }
}

extension PurchaseService {

    enum Action {

        case purchase(productID: String)
        case restorePurchase
        case loadProducts
        case checkPremium
        case dismiss
    }

    enum State {

        case refreshed(isPremium: Bool, products: [Product], showSheet: Bool)
        case refreshing
        case error(String)
        case dismissed
    }
}

extension PurchaseService {

    static func make() -> PurchaseService {

        .init(networkManager: NetworkManager.shared)
    }
}



//protocol PurchaseServiceRepresentable {
//
//    var statePublisher: Published<PurchaseService.State>.Publisher { get }
//    var productsPublisher: Published<[Package]>.Publisher { get }
//    var action: PassthroughSubject<PurchaseService.Action, Never> { get }
//}
//
//class PurchaseService: PurchaseServiceRepresentable {
//
//    var statePublisher: Published<State>.Publisher { $state }
//    @Published private var state: State = .refreshing
//
//    var action = PassthroughSubject<Action, Never>()
//
//    private let networkManager: NetworkManagerRepresentable
//    private var subscriptions = Set<AnyCancellable>()
//
//    var productsPublisher: Published<[Package]>.Publisher { $products }
//    @Published private var products: [Package] = []
//
//    @AppStorage(UserDefaultsKeys.user.rawValue) private var persistedUserId: String?
//    @AppStorage(UserDefaultsKeys.countErrors.rawValue) private var countErrors = 0
//
//    init(networkManager: NetworkManagerRepresentable) {
//
//        self.networkManager = networkManager
//
//        load()
//    }
//
//    // MARK: - Private
//    private func load() {
//
//        action
//            .debounce(for: 1.5, scheduler: DispatchQueue.main)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] action in
//
//                guard let self, case .checkPremium = action else { return }
//                state = .refreshing
//                checkIfUserIsPremium(showSheet: true)
//            }
//            .store(in: &subscriptions)
//
//        action
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] action in
//
//                guard let self else { return }
//
//                switch action {
//                case .purchase(let package):
//                    state = .refreshing
//                    purchase(package: package)
//
//                case .restorePurchases:
//                    state = .refreshing
//                    restorePurchases()
//
//                case .reloadProducts:
//                    getProducts()
//
//                case .checkPremium:
//                    return
//
//                case .dismissed:
//                    state = .dismissed
//                }
//            }
//            .store(in: &subscriptions)
//
//        loadRevenueCat()
//    }
//
//    private func loadRevenueCat() {
//
//        let userId = UUID().uuidString
//
//        if persistedUserId == nil {
//            persistedUserId = userId
//        }
//
//        Purchases.logLevel = .error
//        Purchases.configure(withAPIKey: "appl_QDMRCBOEVDmTcSOvyHSUzTXdQOg", appUserID: persistedUserId ?? userId)
//
//        checkIfUserIsPremium(showSheet: false)
//    }
//
//    private func registerUser(isPremium: Bool) async {
//
//        do {
//            let user = try await networkManager.load(User.createOrUpdate(isPremium: isPremium))
//            Logger.userService.info("\(user.id.string) with premium \(isPremium) successfully updated")
//        } catch {
//            Logger.userService.error("Something went wrong when creating this user")
//        }
//    }
//
//    private func restorePurchases() {
//
//        Purchases.shared.restorePurchases { [weak self] (customerInfo, error) in
//
//            guard let self else { return }
//
//            if error != nil {
//                state = .error(error?.localizedDescription ?? "Error while restoring")
//                Logger.userService.error("\(persistedUserId ?? "") - Error while restoring")
//                return
//            }
//
//            checkIfUserIsPremium(showSheet: false)
//        }
//    }
//
//    private func purchase(package: Package) {
//
//        Purchases.shared.purchase(package: package) { [weak self] (transaction, _, error, userCancelled) in
//
//            guard let self else { return }
//
//            if error != nil && error?.localizedDescription.contains("Purchase was cancelled") == nil {
//                state = .error(error?.localizedDescription ?? "Error while subscribing")
//                Logger.userService.error("\(persistedUserId ?? "") - Error while subscribing")
//                return
//            }
//
//            if userCancelled {
//                Logger.userService.info("\(persistedUserId ?? "") canceled subscription")
//            }
//
//            checkIfUserIsPremium(showSheet: true)
//        }
//    }
//
//    private func checkIfUserIsPremium(showSheet: Bool) {
//
//        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
//
//            guard let self else { return }
//
//            if error != nil {
//                state = .error(error?.localizedDescription ?? "Error fetching user")
//                state = .error("\(persistedUserId ?? "") Error fetching user")
//                return
//            }
//
//            countErrors = 0
//            let isPremium = customerInfo?.entitlements.all[Entitlements.premium.rawValue]?.isActive == true
//
//            Logger.userService.info("\(persistedUserId ?? "") premium is \(isPremium)")
//
//            Task { [weak self] in
//
//                guard let self else { return }
//                await registerUser(isPremium: isPremium)
//            }
//
//            state = .refreshed(isPremium: isPremium, showSheet: showSheet)
//        }
//    }
//
//    private func getProducts() {
//
//        Purchases.shared.getOfferings { [weak self] offerings, error in
//
//            guard let self else { return }
//
//            if let packages = offerings?.offering(identifier: Entitlements.offering.rawValue)?
//                .availablePackages {
//                    products = packages
//            }
//        }
//    }
//}
//
//extension PurchaseService {
//
//    enum Action {
//
//        case dismissed
//        case purchase(Package)
//        case restorePurchases
//        case reloadProducts
//        case checkPremium
//    }
//
//    enum State: Equatable {
//
//        case dismissed
//        case refreshed(isPremium: Bool, showSheet: Bool)
//        case refreshing
//        case error(String)
//    }
//
//    enum Entitlements: String {
//
//        case premium = "com.tomasmamede.slipstream.premium"
//        case offering = "com.tomasmamede.slipstream.offerings-premium"
//    }
//
//}
//
//extension PurchaseService {
//
//    static func make() -> PurchaseService {
//
//        .init(networkManager: NetworkManager.shared)
//    }
//}
