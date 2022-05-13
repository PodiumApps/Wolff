//
//  ExtensionDelegate.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 12/05/2022.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        // TODO: Add device token to firebase
    }
    
}
