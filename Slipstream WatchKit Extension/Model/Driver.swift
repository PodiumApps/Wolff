//
//  Driver.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import Foundation

struct Driver: Codable {
    
    var name: String
    var team: String
    var pointsThisSeason: String
    var carNumber: String
    var country: String
    var podiums: String
    var allTimePoints: String
    var grandPrixEntered: String
    var worldChampionships: String
    var highestRaceFinish: String
    var highestGridPosition: String
    var dateOfBirth: String
    var placeOfBirth: String
}

var driver = Driver(name: "Charles Leclerc", team: "Ferrari", pointsThisSeason: "26", carNumber: "16", country: "Monaco", podiums: "14", allTimePoints: "586", grandPrixEntered: "82", worldChampionships: "N/A", highestRaceFinish: "1 (x3)", highestGridPosition: "1", dateOfBirth: "16/10/1997", placeOfBirth: "Monte Carlo, Monaco")

func decodeDriversJSON() -> [Driver]? {
    let decoder = JSONDecoder()
    
    if let path = Bundle.main.url(forResource: "driver_standings", withExtension: "json") {
        
        let data = try? Data(contentsOf: path)
        
        if let data = data {
            print(data)
            let drivers = try? decoder.decode([Driver].self, from: data)
            return drivers
        }
    }
    
    return nil
}
