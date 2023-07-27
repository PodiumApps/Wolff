import Foundation
import Combine
import RevenueCat

protocol InAppPurchaseViewModelRepresentable: ObservableObject {
    
    var products: [InAppPurchaseViewModel.Product] { get }
    var action: PassthroughSubject<InAppPurchaseViewModel.Action, Never> { get }
    var state: InAppPurchaseViewModel.State { get }
}

class InAppPurchaseViewModel: InAppPurchaseViewModelRepresentable {
    
    struct Product: Identifiable, Hashable {
        
        typealias ID = Identifier<Product>
        
        let id: ID
        let label: String
    }
    
    @Published var products: [Product] = []
    var action = PassthroughSubject<InAppPurchaseViewModel.Action, Never>()

    @Published var state: InAppPurchaseViewModel.State = .results(
        isPremium: false,
        label: Localization.InAppPurchaseView.body
    )
    
    
    private var purchaseService: PurchaseServiceRepresentable
    private var subscriptions = Set<AnyCancellable>()
    private var packages = [Package]()
    
    init(purchaseService: PurchaseServiceRepresentable) {
        
        self.purchaseService = purchaseService
        
        setupBindings()
    }
    
    // MARK: - Private
    private func setupBindings() {
        
        purchaseService
            .productsPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] packages in

                guard let self else { return nil }
                
                self.packages = packages
                
                let products: [Product] = packages.reduce([], { partialResult, package in
                    guard let period =  package.storeProduct.subscriptionPeriod else { return partialResult }
                    
                    return partialResult + [
                        .init(
                            id: .init(package.storeProduct.productIdentifier),
                            label: "\(package.localizedPriceString) / \(period.localizedDescription)"
                        )
                    ]
                })

                if products.isEmpty {

                    state = .error(label: Localization.ErrorScreen.Subscriptions.label)
                    return nil
                }

                return products
            }
            .assign(to: &$products)
        
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }
                
                self.state = .loading(label: Localization.InAppPurchaseView.Body.loading)
                
                switch action {
                case .restore:
                    self.purchaseService.action.send(.restorePurchases)
                case .purchase(let productId):
                    self.buyProduct(id: productId)
                case .reload:
                    self.purchaseService.action.send(.reloadProducts)
                }
            }
            .store(in: &subscriptions)
        
        
        purchaseService
            .statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { state in
                
                switch state {
                case .refreshed(let isPremium, _):
                    let messageLabel = isPremium
                    ? Localization.InAppPurchaseView.Body.success
                    : Localization.InAppPurchaseView.body
                    return .results(isPremium: isPremium, label: messageLabel)
                case .refreshing:
                    return .loading(label: Localization.InAppPurchaseView.Body.loading)
                case .error:
                    return .error(label: Localization.InAppPurchaseView.Body.error)
                case .dismissed:
                    return nil
                }
            }
            .assign(to: &$state)
    }
    
    private func buyProduct(id: Product.ID) {
        
        guard
            let package = packages
                .first(where: { $0.storeProduct.productIdentifier == id.string })
        else {
            state = .error(label: Localization.InAppPurchaseView.Body.error)
            return
        }
        
        purchaseService.action.send(.purchase(package))
    }
}

extension InAppPurchaseViewModel {
    
    enum Action {
        
        case purchase(Product.ID)
        case restore
        case reload
    }
    
    enum State: Equatable {
        
        case loading(label: String)
        case results(isPremium: Bool, label: String)
        case error(label: String)
    }
}

extension InAppPurchaseViewModel {
    
    static func make() -> InAppPurchaseViewModel {
        
        .init(purchaseService: ServiceLocator.shared.purchaseService)
    }
}

fileprivate extension SubscriptionPeriod {
    
    var localizedDescription: String {
        
        let localization = Localization.InAppPurchaseView.SubscriptionPeriod.self
        
        switch unit {
        case .day: return value > 1 ? localization.days : localization.day
        case .week: return value > 1 ? localization.weeks : localization.week
        case .month: return value > 1 ? localization.months : localization.month
        case .year: return localization.year
        }
    }
}
