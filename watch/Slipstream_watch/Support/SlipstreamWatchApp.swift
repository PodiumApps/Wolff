import SwiftUI
import WatchKit
import UserNotifications

@main
struct SlipstreamWatch_Watch_AppApp: App {

    @WKExtensionDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(viewModel: AppViewModel.make(appDelegate: appDelegate))
        }

        WKNotificationScene(controller: LatestNewsNotificationController.self, category: "latest-news")
    }
}
