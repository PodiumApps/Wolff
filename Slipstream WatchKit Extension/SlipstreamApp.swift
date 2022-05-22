//
//  SlipstreamApp.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//


import SwiftUI
import Firebase

@main
struct SlipstreamApp: App {
    
    @WKExtensionDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
    }
    
    @SceneBuilder var body: some Scene {
        
        WindowGroup {
            AppEntryPoint()
        }
        
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
