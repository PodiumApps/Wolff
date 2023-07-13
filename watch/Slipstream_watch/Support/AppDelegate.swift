import Foundation
import Combine
import SwiftUI
import WatchKit
import UserNotifications

class AppDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {

    private let networkManager = NetworkManager.shared

    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {

        UNUserNotificationCenter.current().delegate = self

        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()

        print("APNS Token: \(token)")

        Task { [weak self] in

            guard let self else { return }

            try await networkManager.load(User.update(deviceToken: token))
        }
    }

    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {

        print(error.localizedDescription)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

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
