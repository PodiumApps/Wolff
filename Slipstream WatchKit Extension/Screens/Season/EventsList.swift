//
//  EventsList.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI

struct EventsList: View {
    
    var sessions: [Session]
    var liveEventIsOccuring: String
    var events: SeasonSchedule
    var eventsInArray: [(String, [Event])] {
        return [
            ("Current", !events.currentEvent.isEmpty ? events.currentEvent : []),
            ("Upcoming", !events.upcomoingEvents.isEmpty ? events.upcomoingEvents : []),
            ("Past", !events.pastEvents.isEmpty ? events.pastEvents.reversed() : [])
        ]
    }
    
    var body: some View {
        NavigationView {
            List {
                
                if eventsInArray[0].1.isEmpty && eventsInArray[1].1.isEmpty && eventsInArray[2].1.isEmpty {
                    VStack {
                        Text("There are no events to be shown at this time. Come back later.")
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .listRowBackground(Color.clear)
                }
                else {
                    ForEach(0 ..< eventsInArray.count, id: \.self) { i in
                        Section(eventsInArray[i].0) {
                            
                            if eventsInArray[i].1.isEmpty {
                                VStack {
                                    Text("There are no \(eventsInArray[i].0.lowercased()) events to be shown at this time. Come back later.")
                                        .font(.caption2)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }
                                .listRowBackground(Color.clear)
                            }
                            else {
                                ForEach(0 ..< eventsInArray[i].1.count, id: \.self) { index in
                                    NavigationLink(destination: {
                                        EventMenu(
                                            event: eventsInArray[i].1[index],
                                            sessions: getSessionsForEvent(event: eventsInArray[i].1[index]),
                                            liveEventIsOccuring: liveEventIsOccuring,
                                            index: i
                                        )
                                    }, label: {
                                        HStack {

                                            if let image = UIImage(named: eventsInArray[i].1[index].eventName) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .frame(width: 40, height: 28, alignment: .center)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    .scaledToFit()
                                            }
                                            else {
                                                AsyncImage(url: URL(string: eventsInArray[i].1[index].countryImage)) { image in
                                                    image.resizable()

                                                } placeholder: {
                                                    Color.white
                                                }
                                                .frame(width: 40, height: 28, alignment: .center)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .scaledToFit()
                                            }
                                            
                                            Text("\(eventsInArray[i].1[index].eventName)")
                                                .padding(.leading, 6)
                                            Spacer()
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("Season"))
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    private func getSessionsForEvent(event: Event) -> [Session] {
        
        var sessionsForEvent = [Session]()
        let eventIdString = event.id
        let eventId = eventIdString.split(separator: "/").last?.split(separator: ".")[0]
        
        for session in sessions {
            let sessionId = session.id.split(separator: "/").last?.split(separator: ".")[0]
            if eventId == sessionId {
                sessionsForEvent.append(session)
            }
        }
        
        sessionsForEvent.sort(by: { $0.timestamp > $1.timestamp })
        return sessionsForEvent
    }
}

struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsList(sessions: [session], liveEventIsOccuring: "0", events: seasonSchedule)
    }
}
