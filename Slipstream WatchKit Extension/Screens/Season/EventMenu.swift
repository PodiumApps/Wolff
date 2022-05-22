//
//  EventMenu.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI

struct EventMenu: View {
    
    var event: Event
    var sessions: [Session]
    
    var body: some View {
        VStack {
            HStack {
                Text(event.eventName.uppercased())
                Spacer()
            }
            .padding(.leading, 10)
            
            Divider()
            
            if sessions.isEmpty {
                Text("There are no sessions available.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Divider()
                
                List {
                    NavigationLink(destination: {
                        TrackInfo(event: event)
                    }, label: {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("More Info")
                                .padding(.leading, 5)
                            Spacer()
                        }
                    })
                }
                .padding(.top)
            }
            else {
                List {
                    
                    Section(content: {
                        ForEach(0 ..< sessions.count, id: \.self) { i in
                            NavigationLink(destination: {
                                SessionGrid(
                                    classifications: sessions[i].currentClassifications,
                                    eventTitle: sessions[i].eventTitle,
                                    status: sessions[i].status
                                )
                            }, label: {
                                Text(sessions[i].eventTitle)
                            })
                        }
                    }, header: {
                        Text("Sessions")
                    })
                    
                    NavigationLink(destination: {
                        TrackInfo(event: event)
                    }, label: {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("More Info")
                                .padding(.leading, 5)
                            Spacer()
                        }
                    })
                }
                .padding(.top)
            }
        }
    }
}

struct EventMenu_Previews: PreviewProvider {
    static var previews: some View {
        EventMenu(event: seasonSchedule.currentEvent[0], sessions: [])
    }
}
