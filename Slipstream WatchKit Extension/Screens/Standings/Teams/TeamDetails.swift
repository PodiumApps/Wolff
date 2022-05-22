//
//  TeamDetails.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI

struct TeamDetails: View {
    
    var team: Team
    var drivers: [Driver]
    
    var properties: [(String, String)] {
        var arr: [(String, String)] = []
        
        let name = team.name; arr.append(("Name", name))
        let pointsThisSeason = team.pointsThisSeason; arr.append(("Points This Season", pointsThisSeason))
        let base = team.base; arr.append(("Base", base))
        let teamChief = team.teamChief; arr.append(("Team Chief", teamChief))
        let technicalChief = team.technicalChief; arr.append(("Technical Chief", technicalChief))
        let chasis = team.chasis; arr.append(("Chasis", chasis))
        let powerUnit = team.powerUnit; arr.append(("Power Unit", powerUnit))
        let firstTeamEntry = team.firstTeamEntry; arr.append(("First Team Entry", firstTeamEntry))
        let worldChampionships = team.worldChampionships; arr.append(("World Championships", worldChampionships))
        let highestRaceFinish = team.highestRaceFinish; arr.append(("Highest Race Finish", highestRaceFinish))
        let polePositions = team.polePositions; arr.append(("Pole Positions", polePositions))
        let fastestLaps = team.fastestLaps; arr.append(("Fastest Laps", fastestLaps))
        
        return arr
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(properties[0].1.uppercased())
                    Spacer()
                }
                .padding(.leading)
                Divider()
                ScrollView {
                    ForEach(1 ..< properties.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(properties[index].0.uppercased())
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .padding(.leading)
                            Text(properties[index].1)
                                .font(.caption)
                                .padding(.leading)
                            Divider()
                        }
                    }
                    
                    if let drivers = drivers, (drivers.count > 1) {
                        VStack(alignment: .leading) {
                            Text("DRIVERS")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .padding(.leading)
                            
                            ForEach(0 ..< drivers.count, id: \.self) { index in
                                
                                NavigationLink(destination: {
                                    DriverDetails(driver: drivers[index])
                                }, label: {
                                    
                                    GeometryReader { geometry in
//                                        VStack {
//                                            Spacer()
                                            
                                            HStack {
                                                
                                                RoundedRectangle(cornerRadius: 120)
                                                    .frame(width: geometry.size.width / 35, height: geometry.size.height, alignment: .center)
                                                    .foregroundColor(getTeamColor(teamName: drivers[index].team))
                                                
                                                
                                                
                                                Text(drivers[index].name)
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .padding(.leading, 6)
                                                
                                                Spacer()
                                            }
                                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                            
//                                            Spacer()
//                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TeamDetails_Previews: PreviewProvider {
    static var previews: some View {
        TeamDetails(
            team: team,
            drivers: [driver, driver]
        )
    }
}
