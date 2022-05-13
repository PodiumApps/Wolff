//
//  Standings.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 28/03/2022.
//

import SwiftUI

struct Standings: View {
    
    var teams: [Team]
    var drivers: [Driver]
    
    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(destination: {
                    DriverStandings(drivers: drivers)
                }, label: {
                    HStack {
                        Text("Drivers")
                            //.bold()
                        Spacer()
                    }
                })
                
                NavigationLink(destination: {
                    TeamStandings(teams: teams, drivers: drivers)
                }, label: {
                    HStack {
                        Text("Constructors")
                            //.bold()
                        Spacer()
                    }
                })
                
                Spacer()
            }
            .navigationTitle(Text("Standings"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Standings_Previews: PreviewProvider {
    static var previews: some View {
        Standings(teams: [], drivers: [])
    }
}
