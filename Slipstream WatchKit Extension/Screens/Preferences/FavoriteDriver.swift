//
//  Favorites.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 22/05/2022.
//

import SwiftUI
import FirebaseDatabase

struct FavoriteDriver: View {
    
    
    var drivers: [String]
    @State private var ref: DatabaseReference!
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
        .onDisappear {
            if let userId = UserDefaults.standard.object(forKey: "id") as? String {
                ref = Database.database().reference().ref.child("/")
                ref.child("users/\(userId)/favoriteDriver").setValue(favoriteDriver)
            }
        }
    }
}

struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteDriver(drivers: [])
    }
}
