//
//  SlipstreamApp.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 21/03/2022.
//

import SwiftUI

@main
struct SlipstreamApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
