import SwiftUI
import UserNotifications

class LatestNewsNotificationController: WKUserNotificationHostingController<LatestNewsNotificationView> {

    var newsTitle: String!

    override var body: LatestNewsNotificationView {
        LatestNewsNotificationView(title: newsTitle)
    }

    override func didReceive(_ notification: UNNotification) {

        self.newsTitle = notification.request.content.body
    }
}

struct LatestNewsNotificationView: View {

    var isActiveLatestNewsNotification: Bool = false

    var title: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .Spacing.default) {
                Text("Slipstream News")
                    .font(.Body.semibold)
                Text(title)
                    .font(.Body.regular)
            }
            .frame(width: .infinity)

            Spacer()
        }
    }
}



