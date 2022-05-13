//
//  EventDetails.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 28/03/2022.
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
        let trackImage = event.trackImage; arr.append(("Track", trackImage))
        
        return arr
    }
    
    var body: some View {
        GeometryReader { geometry in
            //NavigationView {
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
                                if index != properties.count - 1 {
                                    Text(properties[index].0.uppercased())
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .padding(.leading)
                                    
                                    Text(properties[index].1)
                                        .font(.caption)
                                        .padding(.leading)
                                    Divider()
                                }
                                else {
//                                    Text(properties[index].0.uppercased())
//                                        .font(.caption2)
//                                        .foregroundColor(.gray)
//                                        .padding(.leading)
//
//                                    AsyncImage(url: URL(string: properties[index].1)) { image in
//                                        image.resizable()
//
//                                    } placeholder: {
//                                        Color.white
//                                    }
//                                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                                    .scaledToFit()
                                    
                                    //print(properties[index].1)
//                                    Link(destination: URL(string: properties[index].1)!, label: {
//                                        Text("Track Layout")
//                                    })
//                                    .buttonStyle(.plain)
//                                    .font(.caption)
//                                    .foregroundColor(.blue)
//                                    .padding([.leading, .top])
                                    
                                    //Divider()
                                        
                                        
//                                    if let url = URL(string: properties[index].1) {
//                                        Link(destination: url, label: {
//                                            Text("Track Layout")
//                                        })
//
//                                        Divider()
//                                    }
                                }
                            }
                        }
                    }
                    
                }
            //}
        }
    }
}

struct EventDetails_Previews: PreviewProvider {
    static var previews: some View {
        TrackInfo(event: seasonSchedule.currentEvent[0])
    }
}
