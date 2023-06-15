import SwiftUI
import UserNotifications

@main
struct SlipstreamWatch_Watch_AppApp: App {

    @StateObject var notificationCenter = NotificationCenter()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(viewModel: AppViewModel.make())
        }
    }
}
