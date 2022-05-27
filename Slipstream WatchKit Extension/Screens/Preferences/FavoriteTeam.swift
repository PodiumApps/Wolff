//
//  FavoriteTeam.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 22/05/2022.
//

import SwiftUI
import FirebaseDatabase

struct FavoriteTeam: View {
    
    
    var teams: [String]
    @State private var ref: DatabaseReference!
    @AppStorage("favorite_team") var favoriteTeam = "Ferrari"
    
    var body: some View {
        Form {
            Picker("Favorite Team", selection: $favoriteTeam, content: {
                ForEach(teams, id: \.self) { team in
                    Text(team)
                }
            })
            .pickerStyle(.inline)
        }
        .onDisappear {
            if let userId = UserDefaults.standard.object(forKey: "id") as? String {
                ref = Database.database().reference().ref.child("/")
                ref.child("users/\(userId)/favoriteTeam").setValue(favoriteTeam)
            }
        }
    }
}

struct FavoriteTeam_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTeam(teams: [])
    }
}
