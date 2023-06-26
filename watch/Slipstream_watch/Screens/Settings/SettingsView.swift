import SwiftUI

struct SettingsView<ViewModel: SettingsViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel
    @State private var isOn = false

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        Form {
        
            if !viewModel.isPremium {
                Section(header: Text(Localization.Settings.premiumSectionTitle)) {

                    Button(action: {
                        viewModel.action.send(.showInAppPurchaseView)
                    }) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text(Localization.Settings.purchasePremiumButtonTitle).bold()
                            Spacer()
                        }
                    }
                }
            }

            Section(header: Text(Localization.Settings.notificationsSectionTitle)) {

                ForEach(0 ..< $viewModel.notificationCells.count, id: \.self) { index in

                    Toggle(
                        viewModel.notificationCells[index].category.label,
                        isOn: $viewModel.notificationCells[index].isOn
                    )
                }
            }
        }
        .navigationTitle(Localization.Settings.screenTitle)
    }
}
