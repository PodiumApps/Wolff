//
//  AppDelegate.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 15/05/2022.
//

import Foundation
import WatchKit
import UserNotifications
import Firebase

class AppDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {
    
    func applicationDidFinishLaunching() {
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { authorization, error in
                if error == nil {
                    if authorization == true {
                        UserDefaults.standard.set(true, forKey: "notification_auth")
                    }
                    else {
                        UserDefaults.standard.set(false, forKey: "notification_auth")
                    }
                }
            }
        )
        
        WKExtension.shared().registerForRemoteNotifications()
    }
    
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        <#code#>
    }
}
