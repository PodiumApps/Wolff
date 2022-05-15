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
    
    @WKExtensionDelegateAdaptor(AppDelegate.self) var delegate
    
    @SceneBuilder var body: some Scene {
        
        WindowGroup {
            AppEntryPoint()
        }
        
    }
}
