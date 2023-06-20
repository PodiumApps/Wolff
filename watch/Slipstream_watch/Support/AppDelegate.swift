import Foundation
import SwiftUI
import WatchKit
import UserNotifications

class AppDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {

    func applicationDidFinishLaunching() {

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]

        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { authorised, error in

                guard error == nil else { return }
                
                if authorised {

                    @AppStorage(UserDefaultsKeys.isActiveSessionStartedNotification.rawValue)
                    var isActiveSessionStartedNotification: Bool = true

                    @AppStorage(UserDefaultsKeys.isActiveSessionEndedNotification.rawValue)
                    var isActiveSessionEndedNotification: Bool = true
                } else {

                    @AppStorage(UserDefaultsKeys.isActiveSessionStartedNotification.rawValue)
                    var isActiveSessionStartedNotification: Bool = false

                    @AppStorage(UserDefaultsKeys.isActiveSessionEndedNotification.rawValue)
                    var isActiveSessionEndedNotification: Bool = false
                }
            }
        )

        WKExtension.shared().registerForRemoteNotifications()
    }

    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {

        print(deviceToken.description)
    }

    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {

        print(error.localizedDescription)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.badge, .sound, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        completionHandler()
    }
}
