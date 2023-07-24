import SwiftUI

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
