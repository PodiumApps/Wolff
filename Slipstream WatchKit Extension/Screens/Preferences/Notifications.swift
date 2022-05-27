//
//  Notifications.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 21/05/2022.
//

import SwiftUI
import FirebaseDatabase

struct Notifications: View {
    
    @AppStorage("startEventNotifications") var startSessionNotifications = true
    @AppStorage("endEventNotifications") var endSessionNotifications = true
    @AppStorage("redFlag") var redFlagNotifications = true
    @AppStorage("favoriteDriver") var favoriteDriverNotifications = true
    @AppStorage("favoriteTeam") var favoriteTeamNotifications = true
    @AppStorage("news") var breakingNewsNotifications = true
    
    @State private var ref: DatabaseReference!
    
    var body: some View {
        List {
            
            Toggle(isOn: $startSessionNotifications, label: {
                Text("Start of Session")
                    .font(.caption)
            })
            
            Toggle(isOn: $endSessionNotifications, label: {
                Text("End of Session")
                    .font(.caption)
            })
            
            Toggle(isOn: $redFlagNotifications, label: {
                Text("Red Flag")
                    .font(.caption)
            })
            
            Toggle(isOn: $favoriteDriverNotifications, label: {
                Text("Favorite Driver")
                    .font(.caption)
            })
            
            Toggle(isOn: $favoriteTeamNotifications, label: {
                Text("Favorite Team")
                    .font(.caption)
            })
            
            Toggle(isOn: $breakingNewsNotifications, label: {
                Text("Breaking News")
                    .font(.caption)
            })
        }
        .navigationTitle(Text("Notifications"))
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if let userId = UserDefaults.standard.object(forKey: "id") as? String {
                ref = Database.database().reference().ref.child("/")
                ref.child("users/\(userId)/notifications/startSession").setValue(startSessionNotifications)
                ref.child("users/\(userId)/notifications/endSession").setValue(endSessionNotifications)
                ref.child("users/\(userId)/notifications/redFlag").setValue(redFlagNotifications)
                ref.child("users/\(userId)/notifications/favoriteDriver").setValue(favoriteDriverNotifications)
                ref.child("users/\(userId)/notifications/favoriteTeam").setValue(favoriteTeamNotifications)
                ref.child("users/\(userId)/notifications/breakingNews").setValue(breakingNewsNotifications)
            }
        }
    }
}

struct Notifications_Previews: PreviewProvider {
    static var previews: some View {
        Notifications()
    }
}
