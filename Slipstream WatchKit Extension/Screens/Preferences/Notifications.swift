//
//  Notifications.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 21/05/2022.
//

import SwiftUI

struct Notifications: View {
    
    @AppStorage("startEventNotifications") var startEventNotifications = true
    @AppStorage("endEventNotifications") var endEventNotifications = true
    @AppStorage("favoriteDriver") var favoriteDriverNotifications = true
    @AppStorage("favoriteTeam") var favoriteTeamNotifications = true
    @AppStorage("news") var breakingNewsNotifications = true
    
    var body: some View {
        List {
            
            Toggle(isOn: $startEventNotifications, label: {
                Text("Start of Session")
                    .font(.caption)
            })
            
            Toggle(isOn: $endEventNotifications, label: {
                Text("End of Session")
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
    }
}

struct Notifications_Previews: PreviewProvider {
    static var previews: some View {
        Notifications()
    }
}
