//
//  DriverStandings.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 26/03/2022.
//

import SwiftUI

struct DriverStandings: View {
    
    var drivers: [Driver]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< drivers.count, id: \.self) { index in
                    GeometryReader { geometry in
                        NavigationLink(destination: {
                            DriverDetails(driver: drivers[index])
                        }, label: {
                            VStack {
                                Spacer()
                                
                                HStack {
                                    
                                    RoundedRectangle(cornerRadius: 120)
                                        .frame(width: geometry.size.width / 35, height: geometry.size.height * 0.75, alignment: .center)
                                        .foregroundColor(getTeamColor(teamName: drivers[index].team))
                                    
                                    
                                    
                                    Text("\(index + 1). \(formatDriversName(name: drivers[index].name))")
                                        .padding(.leading, 6)
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                    })
                    }
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
