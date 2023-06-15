import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        print(deviceToken)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithError error: Error) {

        print(error.localizedDescription)
    }
}

