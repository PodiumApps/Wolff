//
//  DriverDetails.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI

struct DriverDetails: View {
    
    var driver: Driver
    
    var properties: [(String, String)] {
        
        var arr: [(String, String)] = []
        
        let name = driver.name; arr.append(("Name", name))
        let team = driver.team; arr.append(("Team", team))
        let pointsThisSeason = driver.pointsThisSeason; arr.append(("Points this Season", pointsThisSeason))
        let carNumber = driver.carNumber; arr.append(("Car Number", carNumber))
        let country = driver.country; arr.append(("Country", country))
        let podiums = driver.podiums; arr.append(("Podiums", podiums))
        let allTimePoints = driver.allTimePoints; arr.append(("All Time Points", allTimePoints))
        let grandPrixEntered = driver.grandPrixEntered; arr.append(("Grand Prix Entered", grandPrixEntered))
        let worldChampionships = driver.worldChampionships; arr.append(("World Championships", worldChampionships))
        let highestRaceFinish = driver.highestRaceFinish; arr.append(("Highest Race Finish", highestRaceFinish))
        let dateOfBirth = driver.dateOfBirth; arr.append(("Data of Birth", dateOfBirth))
        let placeOfBirth = driver.placeOfBirth; arr.append(("Place of Birth", placeOfBirth))
        
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
                }
                
            }
        }
    }
}

struct DriverDetails_Previews: PreviewProvider {
    static var previews: some View {
        DriverDetails(driver: driver)
    }
}
