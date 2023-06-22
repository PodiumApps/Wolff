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

                ForEach(0 ..< $viewModel.notifications.count, id: \.self) { $notification in

                    Toggle(notification.category, isOn: $notification.isOn)
                }
            }
        }
        .navigationTitle(Localization.Settings.screenTitle)
        .onAppear {

            viewModel.action.send(.registerForRemoteNotifications)
            print(viewModel.isActiveSessionStartedNotification)
        }
    }
}
