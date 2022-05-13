//
//  SlipstreamApp.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 21/03/2022.
//

import SwiftUI
import Firebase

@main
struct SlipstreamApp: App {
    
    var ref: DatabaseReference!
    
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate
    
    @SceneBuilder var body: some Scene {
        
        WindowGroup {
            AppEntryPoint()
        }
        
        //WKExtension.shared().registerForRemoteNotifications()
    }
    
    init() {
        UserDefaults.standard.removeObject(forKey: "id")
        
        let uuid = UserDefaults.standard.object(forKey: "id") as? String ?? ""
        print("UUID: \(uuid)")
        if uuid == "" {
            let newUUID = UUID().description
            UserDefaults.standard.set(newUUID, forKey: "id")
            
            FirebaseApp.configure()
            
            var ref: DatabaseReference!
            ref = Database.database().reference().ref.child("/")
            ref.child("users/\(newUUID)/token").setValue("sfdsmdodmas")
        }
    }
}
