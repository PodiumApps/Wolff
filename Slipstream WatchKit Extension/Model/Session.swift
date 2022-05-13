//
//  Session.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 23/04/2022.
//

import Foundation

struct Session: Codable {
    var timestamp: String
    var id: String
    var eventTitle: String
    var currentClassifications: [DriverDetailsForSession]
    var status: [String]
}

var session = Session(
    timestamp: "175638493",
    id: "EmiliaRomagna",
    eventTitle: "Qualifying (Q3)",
    currentClassifications: [driverDetailsForSession],
    status: ["Live", "19.1 ºC", "", "Red Flag"]
)

func decodeSessionsJSON() -> [Session]? {
    
    let decoder = JSONDecoder()
    
    if let path = Bundle.main.url(forResource: "sessions", withExtension: "json") {
        let data = try? Data(contentsOf: path)
        
        if let data = data {
            let sessions = try? decoder.decode([Session].self, from: data)
            return sessions
        }
    }
    
    return nil
}
