import Foundation
import Combine
import StoreKit

protocol InAppPurchaseViewModelRepresentable: ObservableObject {
    
    var products: [Product] { get }
    var action: PassthroughSubject<InAppPurchaseViewModel.Action, Never> { get }
    var state: InAppPurchaseViewModel.State { get }
}

class InAppPurchaseViewModel: InAppPurchaseViewModelRepresentable {

    @Published var products: [Product] = []
    var action = PassthroughSubject<InAppPurchaseViewModel.Action, Never>()

    @Published var state: InAppPurchaseViewModel.State = .results(
        isPremium: false,
        label: Localization.InAppPurchaseView.body
    )

    private var purchaseService: PurchaseServiceRepresentable
    private var subscriptions = Set<AnyCancellable>()
    
    init(purchaseService: PurchaseServiceRepresentable) {
        
        self.purchaseService = purchaseService
        
        setupBindings()
    }
    
    // MARK: - Private
    private func setupBindings() {
        
        purchaseService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] purchaseService -> InAppPurchaseViewModel.State? in

                guard let self else { return nil }

                switch purchaseService {
                case .refreshed(let isPremium, let products, _):

                    self.products = products
                    return .results(isPremium: isPremium, label: Localization.InAppPurchaseView.body)
                case .refreshing:
                    return .loading(label: Localization.InAppPurchaseView.Body.loading)
                case .error:
                    return .error(label: Localization.InAppPurchaseView.Body.error)
                case .dismissed:
                    return nil
                }
            }
            .assign(to: &$state)

        
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }
                
                self.state = .loading(label: Localization.InAppPurchaseView.Body.loading)
                
                switch action {
                case .restore:
                    self.purchaseService.action.send(.restorePurchase)
                case .purchase(let productId):
                    self.buyProduct(id: productId)
                case .reload:
                    self.purchaseService.action.send(.loadProducts)
                }
            }
            .store(in: &subscriptions)
        
        
        purchaseService
            .statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { state in
                
                switch state {
                case .refreshed(let isPremium, _, _):
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
    
    private func buyProduct(id: String) {

        purchaseService.action.send(.purchase(productID: id))
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
