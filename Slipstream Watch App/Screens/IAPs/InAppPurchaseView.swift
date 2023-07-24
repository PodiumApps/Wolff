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

                switch viewModel.state {
                case .error(let error):
                    VStack {
                        Spacer()
                        Text(error)
                            .font(.caption)
                        Spacer()
                        Button("Try again") {
                            viewModel.action.send(.reload)
                        }
                    }
                case .loading(let label):
                    VStack(spacing: .Spacing.default2) {
                        Spacer()
                        ProgressView()
                        Text(label)
                            .font(.Body.regular)
                        Spacer()
                    }
                case .results(let isPremium, let label):
                    Text(label)
                        .font(.Body.regular)

                    if !isPremium {
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
                    }
                }
            }
            .padding(5)
        }
    }
}
