import SwiftUI

struct SettingsView<ViewModel: SettingsViewModelRepresentable>: View {

    @AppStorage(UserDefaultsKeys.user.rawValue) private var persistedUserId: String?

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
            } else {

                Text("Your Premium subscription is active.")
                    .font(.Caption2.medium)
            }

            Section(header: Text(Localization.Settings.notificationsSectionTitle)) {

                ForEach(0 ..< $viewModel.notificationCells.count, id: \.self) { index in

                    Toggle(
                        viewModel.notificationCells[index].category.label,
                        isOn: $viewModel.notificationCells[index].isOn
                    )
                }
            }

            Section {

                Button(action: {
                    viewModel.action.send(.showPrivacyPolicyView)
                }) {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Privacy Policy")
                        Spacer()
                    }
                }

                Button(action: {
                    viewModel.action.send(.showTermsAndConditionsView)
                }) {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Terms & Conditions")
                        Spacer()
                    }
                }
            }

            if let userID = persistedUserId {

                Section(header: Text("User ID")) {

                    Text(userID)
                        .font(.Caption.regular)
                        .listRowBackground(Color.clear)
                }
            }
        }
        .navigationTitle(Localization.Settings.screenTitle)
        .fullScreenCover(isPresented: $viewModel.activateNotificationsActionSheet) {
            Text(Localization.Settings.warningActivateNotificationsIphone)
                .font(.Body.regular)
        }
    }
}
