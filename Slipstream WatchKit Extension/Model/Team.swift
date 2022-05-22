//
//  Team.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import Foundation
import SwiftUI

struct Team: Codable {
    var name: String
    var pointsThisSeason: String
    var base: String
    var teamChief: String
    var technicalChief: String
    var chasis: String
    var powerUnit: String
    var firstTeamEntry: String
    var worldChampionships: String
    var highestRaceFinish: String
    var polePositions: String
    var fastestLaps: String
}

var team = Team(name: "Ferrari", pointsThisSeason: "44", base: "Maranello, Italy", teamChief: "Mattia Binotto", technicalChief: "Enrico Cardile / Enrico Gualtieri", chasis: "F1-75", powerUnit: "Ferrari", firstTeamEntry: "1950", worldChampionships: "16", highestRaceFinish: "1 (x240)", polePositions: "231", fastestLaps: "254")

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

func decodeTeamsJSON() -> [Team]? {
    let decoder = JSONDecoder()
    
    if let path = Bundle.main.url(forResource: "team_standings", withExtension: "json") {
        
        let data = try? Data(contentsOf: path)
        
        if let data = data {
            let teams = try? decoder.decode([Team].self, from: data)
            return teams
        }
    }
    
    return nil
}
