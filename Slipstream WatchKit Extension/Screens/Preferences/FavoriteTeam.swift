//
//  FavoriteTeam.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 22/05/2022.
//

import SwiftUI

struct FavoriteTeam: View {
    
    var teams: [String]
    
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
    }
}

struct FavoriteTeam_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTeam(teams: [])
    }
}
