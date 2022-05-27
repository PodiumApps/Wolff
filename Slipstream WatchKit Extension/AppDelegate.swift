//
//  AppDelegate.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import Foundation
import WatchKit
import UserNotifications
import Firebase

class AppDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {
    
    var ref: DatabaseReference!
    
    func applicationDidFinishLaunching() {
        
        //UserDefaults.standard.removeObject(forKey: "id")
        
        let uuid = UserDefaults.standard.object(forKey: "id") as? String
        
        if uuid == nil {
            let newUUID = UUID().description
            UserDefaults.standard.set(newUUID, forKey: "id")
        }
        
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
        
        FirebaseApp.configure()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().ref.child("/")
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        if let userID = UserDefaults.standard.object(forKey: "id") as? String {
            ref.child("users/\(userID)/token").setValue(token)
        }
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //let content = response.notification.request.content.title
        completionHandler()
    }
}

