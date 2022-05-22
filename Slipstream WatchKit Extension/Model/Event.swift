//
//  Event.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import Foundation

struct Event: Codable {
    
    var id: String
    var eventName: String
    var date: String
    var circuitName: String
    var firstGrandPrix: String
    var numberOfLaps: String
    var circuitLength: String
    var raceDistance: String
    var lapRecord: String
    var countryImage: String
    var trackImage: String
}

struct SeasonSchedule: Codable {
    
    var currentEvent: [Event]
    var upcomoingEvents: [Event]
    var pastEvents: [Event]
}

var seasonSchedule = SeasonSchedule(currentEvent: [Event(id: "https://www.formula1.com/en/racing/2022/Pre-Season-Track-Session.html", eventName: "United States", date: "25 - 27 Mar2022", circuitName: "Jeddah Corniche Circuit", firstGrandPrix: "2021", numberOfLaps: "50", circuitLength: "6.174km", raceDistance: "308.45 km", lapRecord: "1:30.734 Lewis Hamilton (2021)", countryImage: "https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Flags%2016x9/saudi-arabia-flag.png.transform/9col/image.png", trackImage: "https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Saudi_Arabia_Circuit.png.transform/9col/image.png")], upcomoingEvents: [Event(id: "https://www.formula1.com/en/racing/2022/Pre-Season-Track-Session.html", eventName: "Australia", date: "08 - 10 Apr2022", circuitName: "Melbourne Grand Prix Circuit", firstGrandPrix: "1996", numberOfLaps: "58", circuitLength: "5.303km", raceDistance: "307.574 km", lapRecord: "1:24.125 Michael Schumacher (2004)", countryImage: "https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Flags%2016x9/australia-flag.png.transform/9col/image.png", trackImage: "https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Australia_Circuit.png.transform/9col/image.png"), Event(id: "https://www.formula1.com/en/racing/2022/Pre-Season-Track-Session.html", eventName: "Italy", date: "22 - 24 Apr2022", circuitName: "Autodromo Enzo e Dino Ferrari", firstGrandPrix: "1980", numberOfLaps: "63", circuitLength: "4.909km", raceDistance: "309.049 km", lapRecord: "1:15.484 Lewis Hamilton (2020)", countryImage: "https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Flags%2016x9/italy-flag.png.transform/9col/image.png", trackImage: "https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Emilia_Romagna_Circuit.png.transform/9col/image.png")], pastEvents: [Event(id: "https://www.formula1.com/en/racing/2022/Pre-Season-Track-Session.html", eventName: "Bahrain", date: "18 - 20 Mar2022", circuitName: "Bahrain International Circuit", firstGrandPrix: "2004", numberOfLaps: "57", circuitLength: "5.412km", raceDistance: "308.238 km", lapRecord: "1:31.447 Pedro de la Rosa (2005)", countryImage: "https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Flags%2016x9/bahrain-flag.png.transform/9col/image.png", trackImage: "https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/Circuit%20maps%2016x9/Bahrain_Circuit.png.transform/9col/image.png")])


func decodeSeasonSchedule() -> SeasonSchedule? {
    let decoder = JSONDecoder()
    
    if let path = Bundle.main.url(forResource: "season_schedule", withExtension: "json") {
        
        let data = try? Data(contentsOf: path)
        
        if let data = data {
            let schedule = try? decoder.decode(SeasonSchedule.self, from: data)
            print(data.count)
            return schedule
        }
    }
    
    return nil
}
