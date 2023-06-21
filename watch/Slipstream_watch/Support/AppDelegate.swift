import Foundation
import SwiftUI
import WatchKit
import UserNotifications

class AppDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {

    func registerForRemoteNotifications() {

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]

        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { authorised, error in

                guard error == nil else { return }

                if authorised {

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                        UserDefaults.standard.set(
                            true,
                            forKey: UserDefaultsKeys.isActiveSessionStartedNotification.rawValue
                        )

                        UserDefaults.standard.set(
                            true,
                            forKey: UserDefaultsKeys.isActiveSessionEndedNotification.rawValue
                        )

                        UserDefaults.standard.set(
                            true,
                            forKey: UserDefaultsKeys.isActiveLatestNewsNotification.rawValue
                        )
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

        completionHandler([.badge, .sound, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        completionHandler()
    }
}
