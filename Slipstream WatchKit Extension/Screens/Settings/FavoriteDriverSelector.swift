//
//  FavoriteDriverSelector.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 10/05/2022.
//

import SwiftUI

struct FavoriteDriverSelector: View {
    
    @State private var driverSelection = "Max Verstappen"
    
    let drivers = [
        "Charles Leclerc",
        "Max Verstappen",
        "Carlos Sainz",
        "Sergio Perez"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Picker(selection: $driverSelection, content: {
                        ForEach(drivers, id: \.self) { driver in
                            Text(driver)
                        }
                    }, label: {
                        Text("")
                    })
                }
                .frame(height: 100, alignment: .center)
            }
            
            Spacer()
            
            Button("Save") {
                
            }
        }
        .navigationTitle("Favorite Driver")
    }
}

struct FavoriteDriverSelector_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteDriverSelector()
    }
}
