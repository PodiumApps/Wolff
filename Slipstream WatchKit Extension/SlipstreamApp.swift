//
//  SlipstreamApp.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//


import SwiftUI
import Firebase
import FirebaseDatabase

@main
struct SlipstreamApp: App {
    
    @AppStorage("startEventNotifications") var startSessionNotifications = true
    @AppStorage("endEventNotifications") var endSessionNotifications = true
    @AppStorage("redFlag") var redFlagNotifications = true
    @AppStorage("favoriteDriver") var favoriteDriverNotifications = true
    @AppStorage("favoriteTeam") var favoriteTeamNotifications = true
    @AppStorage("news") var breakingNewsNotifications = true
    @AppStorage("favorite_team") var favoriteTeam = "Ferrari"
    @AppStorage("favorite_driver") var favoriteDriver = "Charles Leclerc"
    
    @AppStorage("generalDataTimestamp") var generalDataTimestamp = "0"
    @AppStorage("newsDataTimestamp") var newsDataTimestamp = "0"
    @AppStorage("sessionsDataTimestamp") var sessionsDataTimestamp = "0"
    
    @State private var ref: DatabaseReference!
    
    @StateObject var dataManager = DataManager()
    
    @WKExtensionDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
        
        if UserDefaults.standard.string(forKey: "generalDataTimestamp") == nil {
            UserDefaults.standard.setValue("0", forKey: "generalDataTimestamp")
        }
        
        if UserDefaults.standard.string(forKey: "newsDataTimestamp") == nil {
            UserDefaults.standard.setValue("0", forKey: "newsDataTimestamp")
        }
        
        if UserDefaults.standard.string(forKey: "sessionsDataTimestamp") == nil {
            UserDefaults.standard.setValue("0", forKey: "sessionsDataTimestamp")
        }
    }
    
    @SceneBuilder var body: some Scene {
        
        WindowGroup {
            AppEntryPoint()
                .environmentObject(dataManager)
                .onAppear {
                    if let userId = UserDefaults.standard.object(forKey: "id") as? String {
                        ref = Database.database().reference().ref.child("/")
                        ref.child("users/\(userId)/notifications/startSession").setValue(startSessionNotifications)
                        ref.child("users/\(userId)/notifications/endSession").setValue(endSessionNotifications)
                        ref.child("users/\(userId)/notifications/redFlag").setValue(redFlagNotifications)
                        ref.child("users/\(userId)/notifications/favoriteDriver").setValue(favoriteDriverNotifications)
                        ref.child("users/\(userId)/notifications/favoriteTeam").setValue(favoriteTeamNotifications)
                        ref.child("users/\(userId)/notifications/breakingNews").setValue(breakingNewsNotifications)
                        ref.child("users/\(userId)/favoriteDriver").setValue(favoriteDriver)
                        ref.child("users/\(userId)/favoriteTeam").setValue(favoriteTeam)
                    }
                }
        }
        //WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
