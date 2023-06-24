import Foundation
import Combine
import SwiftUI
import WatchKit
import UserNotifications

class AppDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {

    private var notificationService: NotificationServiceRepresentable

    private var notificationCategories: [NotificationService.NotificationCategory]
    
    private var subscribers = Set<AnyCancellable>()

    init(notificationService: NotificationServiceRepresentable = ServiceLocator.shared.notificationService) {

        self.notificationService = notificationService
        self.notificationCategories = []

        self.setUpBindings()
    }

    private func setUpBindings() {

        notificationService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notificationService in

                guard let self else { return }

                switch notificationService {
                case .refreshed(let notifications):

                    let categories = notifications.compactMap { $0.category }
                    self.notificationCategories = categories
                case .refreshing, error:
                    return
                }
            }
            .assign(to: &subscribers)
    }

    func registerForRemoteNotifications() {

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]

        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { [weak self] authorised, error in

                guard let self, error == nil else { return }

                if authorised {

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                        self.notificationService.action.send(.fetchAll)
                    }
                }
            }
        )

        WKExtension.shared().registerForRemoteNotifications()
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

        guard let allCategories = notificationCategory else { return }

        if allCategories.contains(category) { return }

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
