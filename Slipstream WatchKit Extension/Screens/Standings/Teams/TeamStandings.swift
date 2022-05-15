//
//  TeamStandings.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 26/03/2022.
//

import SwiftUI

struct TeamStandings: View {
    
    var teams: [Team]
    var drivers: [Driver]
    
    var body: some View {
//        NavigationView {
            List {
                ForEach(0 ..< teams.count, id: \.self) { index in
                    GeometryReader { geometry in
                        NavigationLink(destination: {
                            TeamDetails(
                                team: teams[index],
                                drivers: getTeamDrivers(teamName: teams[index].name)
                            )
                        }, label: {
                            VStack {
                                Spacer()
                                
                                HStack {
    //                                ZStack {
    //                                    Circle()
    //                                        .frame(width: 35, height: 35, alignment: .center)
    //                                    Image(teams[index].name)
    //                                        .resizable()
    //                                        .frame(width: 25, height: 25, alignment: .center)
    //                                }
                                    
                                    RoundedRectangle(cornerRadius: 120)
                                        .frame(width: geometry.size.width / 35, height: geometry.size.height * 0.75, alignment: .center)
                                        .foregroundColor(getTeamColor(teamName: teams[index].name))
                                    
                                    
                                    
                                    Text("\(index + 1). \(teams[index].name)")
                                        .padding(.leading, 6)
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                            
                    })
                    }
                }
            }
            .navigationTitle(Text("Constructors"))
            .navigationBarTitleDisplayMode(.inline)
//        }
    }
    
    func getTeamColor(teamName: String) -> Color {
        switch teamName {
        case String("Alfa Romeo"):
            return Color.init(.sRGB, red: 177/255, green: 32/255, blue: 56/255, opacity: 1)
        case "Alpine":
            return Color.init(.sRGB, red: 34/255, green: 147/255, blue: 209/255, opacity: 1)
        case "Ferrari":
            return Color.init(.sRGB, red: 238/255, green: 28/255, blue: 36/255, opacity: 1)
        case "Mercedes":
            return Color.init(.sRGB, red: 93/255, green: 204/255, blue: 177/255, opacity: 1)
        case "Aston Martin":
            return Color.init(.sRGB, red: 45/255, green: 130/255, blue: 109/255, opacity: 1)
        case "McLaren":
            return Color.init(.sRGB, red: 245/255, green: 128/255, blue: 31/255, opacity: 1)
        case  "Williams":
            return Color.init(.sRGB, red: 55/255, green: 190/255, blue: 221/255, opacity: 1)
        case "AlphaTauri":
            return Color.init(.sRGB, red: 77/255, green: 124/255, blue: 155/255, opacity: 1)
        case "Haas F1 Team":
            return Color.init(.sRGB, red: 182/255, green: 186/255, blue: 189/255, opacity: 1)
        case "Red Bull Racing":
            return Color.init(.sRGB, red: 30/255, green: 91/255, blue: 198/255, opacity: 1)
        default:
            return Color.white
        }
    }
    
    func getTeamDrivers(teamName: String) -> [Driver] {
        
        var teamDrivers: [Driver] = []
        for driver in drivers {
            if teamName == driver.team {
                teamDrivers.append(driver)
            }
        }
        
        teamDrivers = teamDrivers.sorted(by: { $0.name < $1.name })
        return teamDrivers
    }
}

struct TeamStandings_Previews: PreviewProvider {
    static var previews: some View {
        TeamStandings(teams: [team], drivers: [])
    }
}