import SwiftUI

struct SettingsView<ViewModel: SettingsViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        Form {
            Section(header: Text("Notifications")) {
                Toggle("Session Start", isOn: $viewModel.isActiveSessionStartedNotification)
                Toggle("Session End", isOn: $viewModel.isActiveSessionEndedNotification)
            }

            if !viewModel.isPremium {
                Section {

                    Button(action: {
                        viewModel.action.send(.showInAppPurchaseView)
                    }) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Purchase Premium").bold()
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}
