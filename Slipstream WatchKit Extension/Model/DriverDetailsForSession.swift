//
//  DriverDetailsForSession.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 23/04/2022.
//

import Foundation

struct DriverDetailsForSession: Codable {
    var name: String
    var position: String
    var time: String
    var tyre: String
    var tyrePitCount: String
    var team: String
}

var driverDetailsForSession = DriverDetailsForSession(
    name: "Max Verstappen",
    position: "1",
    time: "1:27.999",
    tyre: "intermediate-new.png",
    tyrePitCount: "5",
    team: "Red Bull Racing"
)
