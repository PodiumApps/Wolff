import SwiftUI
import RevenueCat
import Combine

struct InAppPurchaseView<ViewModel: InAppPurchaseViewModelRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: .Spacing.default2) {
                Text(Localization.InAppPurchaseView.title)
                    .font(.Title4.regular)
                    .foregroundColor(.accentColor)
                
                Text(viewModel.state.label)
                    .font(viewModel.state == .error ? .Body.semibold : .Body.regular)
                
                VStack(spacing: .Spacing.default3) {
                    
                    ForEach(viewModel.products) { product in
                        
                        Button(product.label) {
                            viewModel.action.send(.purchase(product.id))
                        }
                        .foregroundColor(.white)
                        .buttonStyle(BorderedButtonStyle(tint: .accentColor.opacity(255)))
                    }
                    Button(action: {
                        viewModel.action.send(.restore)
                    }) {
                        Text(Localization.InAppPurchaseView.Button.restore)
                            .font(.Caption.regular)
                    }
                }
                .disabled(viewModel.state == .loading)
                .opacity( viewModel.state == .results(isPremium: true) ? 0 : viewModel.state == .loading ? 0.2 : 1)
            }
            .padding()
        }
    }
}

struct InAppPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        InAppPurchaseView(viewModel: InAppPurchaseViewModel.make())
    }
}

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
    @Published var state: InAppPurchaseViewModel.State = .results(isPremium: false)
    
    
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
                
                self?.packages = packages
                
                return packages.reduce([], { partialResult, package in
                    guard let period =  package.storeProduct.subscriptionPeriod else { return partialResult }
                    
                    return partialResult + [
                        .init(
                            id: .init(package.storeProduct.productIdentifier),
                            label: "\(package.localizedPriceString) / \(period.localizedDescription)"
                        )
                    ]
                })
            }
            .assign(to: &$products)
        
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                
                self?.state = .loading
                
                switch action {
                case .restore:
                    self?.purchaseService.action.send(.restorePurchases)
                case .purchase(let productId):
                    self?.buyProduct(id: productId)
                }
            }
            .store(in: &subscriptions)
        
        
        purchaseService
            .statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { state in
                
                switch state {
                case .refreshed(let isPremium, _):
                    return .results(isPremium: isPremium)
                case .refreshing:
                    return .loading
                case .error:
                    return .error
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
            state = .error
            return
        }
        
        purchaseService.action.send(.purchase(package))
    }
}

extension InAppPurchaseViewModel {
    
    enum Action {
        
        case purchase(Product.ID)
        case restore
    }
    
    enum State: Equatable {
        
        case loading
        case results(isPremium: Bool)
        case error
        
        var label: String {
            switch self {
            case .loading:
                return Localization.InAppPurchaseView.Body.loading
            case .results(let isPremium):
                return isPremium ? Localization.InAppPurchaseView.Body.success : Localization.InAppPurchaseView.body
            case .error:
                return Localization.InAppPurchaseView.Body.error
            }
        }
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
