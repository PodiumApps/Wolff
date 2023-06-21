import SwiftUI

struct SettingsView<ViewModel: SettingsViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

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
                Toggle(
                    Localization.Settings.NotificationLabel.sessionStart,
                    isOn: $viewModel.isActiveSessionStartedNotification
                )

                Toggle(
                    Localization.Settings.NotificationLabel.sessionEnd,
                    isOn: $viewModel.isActiveSessionEndedNotification
                )

                Toggle(
                    Localization.Settings.NotificationLabel.latestNews,
                    isOn: $viewModel.isActiveLatestNewsNotification
                )
            }
        }
        .navigationTitle(Localization.Settings.screenTitle)
        .onAppear {

            viewModel.action.send(.registerForRemoteNotifications)
            print(viewModel.isActiveSessionStartedNotification)
        }
    }
}
