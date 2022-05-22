//
//  TrackInfo.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI

struct TrackInfo: View {
    
    var event: Event
    var properties: [(String, String)] {
        
        var arr: [(String, String)] = []
        
        let eventName = event.eventName; arr.append(("Event Name", eventName))
        let eventDate = event.date; arr.append(("Date", eventDate))
        let circuitName = event.circuitName; arr.append(("Circuit Name", circuitName))
        let firstGrandPrix = event.firstGrandPrix; arr.append(("First Grand Prix", firstGrandPrix))
        let numberOfLaps = event.numberOfLaps; arr.append(("Number Of Laps", numberOfLaps))
        let circuitLength = event.circuitLength; arr.append(("Circuit Length", circuitLength))
        let raceDistance = event.raceDistance; arr.append(("Race Distance", raceDistance))
        let lapRecord = event.lapRecord; arr.append(("Lap Record", lapRecord))
        
        return arr
    }
    
    var body: some View {
        
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

struct EventDetails_Previews: PreviewProvider {
    static var previews: some View {
        TrackInfo(event: seasonSchedule.currentEvent[0])
    }
}
