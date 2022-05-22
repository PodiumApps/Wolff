//
//  Favorites.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 22/05/2022.
//

import SwiftUI

struct FavoriteDriver: View {
    
    var drivers: [String]
    @AppStorage("favorite_driver") var favoriteDriver = "Charles Leclerc"
    
    var body: some View {
        Form {
            Picker("Favorite Driver", selection: $favoriteDriver, content: {
                ForEach(drivers, id: \.self) { driver in
                    VStack {
                        Text(driver)
                    }
                }
            })
            .pickerStyle(.inline)
        }
    }
}

struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteDriver(drivers: [])
    }
}
