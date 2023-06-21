import SwiftUI
import UserNotifications

class LatestNewsNotificationController: WKUserNotificationHostingController<LatestNewsNotificationView> {

    var content: UNNotificationContent!
    var date: Date!

    override var body: LatestNewsNotificationView {
        LatestNewsNotificationView()
    }

    override func didReceive(_ notification: UNNotification) {

        self.content = notification.request.content
        self.date = notification.date
    }
}

struct LatestNewsNotificationView: View {

    var body: some View {
        Text("This is a Notification")
    }
}



