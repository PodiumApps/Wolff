//
//  SessionDriverDetails.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 22/04/2022.
//

import SwiftUI

struct SessionDriverDetails: View {
    
    var driverDetails: DriverDetailsForSession
    
    var properties: [(String, String)] {
        var arr: [(String, String)] = []
        
        let name = ("Name", driverDetails.name); arr.append(name)
        let position = ("Position", driverDetails.position); arr.append(position)
        let time = ("Time", driverDetails.time); arr.append(time)
        let tyre = ("Tyre", convertTyreToString(tyrePNG: driverDetails.tyre)); arr.append(tyre)
        let tyrePitCount = ("Tyre / Pit Count", driverDetails.tyrePitCount); arr.append(tyrePitCount)
        let team = ("Team", driverDetails.team); arr.append(team)

        return arr
    }
    
    var body: some View {
        ScrollView {
            ForEach(0 ..< properties.count, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text(properties[index].0.uppercased())
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.leading)
                    if properties[index].0 == "Tyre" {
                        Text(properties[index].1)
                            .font(.caption)
                            .padding(.leading)
                            .foregroundColor(getTyreColor(tyreType: properties[index].1))
                    }
                    else {
                        Text(properties[index].1)
                            .font(.caption)
                            .padding(.leading)
                    }
                    Divider()
                }
            }
        }
    }
    
    private func convertTyreToString(tyrePNG: String) -> String {
        if tyrePNG == "empty.png" { return "Unknown" }
        return String(tyrePNG.split(separator: "-")[0]).capitalized
    }
    
    private func getTyreColor(tyreType: String) -> Color {
        switch tyreType {
        case "Hard":
            return Color.white
        case "Soft":
            return Color(red: 206 / 255, green: 19 / 255, blue: 23 / 255)
        case "Medium":
            return Color(red: 254 / 255, green: 201 / 255, blue: 9 / 255)
        case "Intermediate":
            return Color(red: 56 / 255, green: 165 / 255, blue: 31 / 255)
        case "Wet":
            return Color(red: 10 / 255, green: 81 / 255, blue: 157 / 255)
        default:
            return Color.gray
        }
    }
}

struct SessionDriverDetails_Previews: PreviewProvider {
    static var previews: some View {
        SessionDriverDetails(driverDetails: driverDetailsForSession)
    }
}
