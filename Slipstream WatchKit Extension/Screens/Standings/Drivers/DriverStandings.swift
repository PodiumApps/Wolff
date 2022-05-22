//
//  DriverStandings.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI

struct DriverStandings: View {
    
    var drivers: [Driver]
    
    var body: some View {
        
        if drivers.isEmpty {
            VStack {
                Text("Can't show driver standings right now. Come back later.")
                    .font(.caption2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .listRowBackground(Color.clear)
            .navigationTitle(Text("Drivers"))
            .navigationBarTitleDisplayMode(.inline)
        }
        else {
            List {
                
                ForEach(0 ..< drivers.count, id: \.self) { index in
                    NavigationLink(destination: {
                        DriverDetails(driver: drivers[index])
                    }, label: {
                        VStack(alignment: .leading) {
                            HStack {
                                
                                RoundedRectangle(cornerRadius: 120)
                                    .frame(width: 4.5, height: 30)
                                    .foregroundColor(getTeamColor(teamName: drivers[index].team))

                                Text("\(index + 1). \(formatDriversName(name: drivers[index].name))")
                                    .padding(.leading, 6)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                    })
                }
            }
                .navigationTitle(Text("Drivers"))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

func formatDriversName(name: String) -> String {
    let arr = name.split(separator: " ")
    if arr.count > 1 {
        return "\(arr[0].first!). \(arr[1])"
    }
    
    return ""
}

struct DriverStandings_Previews: PreviewProvider {
    static var previews: some View {
        DriverStandings(drivers: decodeDriversJSON() ?? [])
    }
}
