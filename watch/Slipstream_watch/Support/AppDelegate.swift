import Foundation
import Combine
import SwiftUI
import WatchKit
import UserNotifications

class AppDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {

    private var notificationService: NotificationServiceRepresentable = ServiceLocator.shared.notificationService

    private var notificationCategories: [NotificationService.NotificationCategory] = []
    
    private var subscribers = Set<AnyCancellable>()

    private func setUpBindings() {

        notificationService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notificationService in

                guard let self else { return }

                switch notificationService {
                case .refreshed(let notifications):

                    let categories = notifications.compactMap { $0.category }
                    self.notificationCategories = categories
                case .refreshing, .error:
                    return
                }
            }
            .store(in: &subscribers)
    }

    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {

        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Token: \(token)")
    }

    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {

        print(error.localizedDescription)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let notificationCategory = NotificationService.NotificationCategory(
            rawValue: notification.request.content.categoryIdentifier
        )

        guard let category = notificationCategory else { return }

        if notificationCategories.contains(category) { return }

        self.setUpBindings()
        completionHandler([.badge, .sound, .banner])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {

        completionHandler()
    }
}
