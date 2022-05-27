//
//  SessionGrid.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI

struct SessionGrid: View {
    
    var classifications: [DriverDetailsForSession]
    var eventTitle: String
    var status: [String]
    var index: Int
    var eventIsOccuring: String
    
    var finalStatus: [String] {
        var newStatus = status
        if index == 0 && eventIsOccuring == "1" {
            newStatus[0] = "LIVE"
        }
        else {
            newStatus.removeAll()
            newStatus.append("FINISHED")
        }
        return newStatus
    }
    
    var body: some View {
        
        if classifications.count > 0 {
            List {
                Section {
                    VStack(alignment: .leading) {
                        ForEach(0 ..< finalStatus.count, id: \.self) { index in
                            if finalStatus[index] != "" {
                                Text(finalStatus[index])
                            }
                        }
                        
                        Divider()
                            .padding(.top)
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section(content: {
                    ForEach(0 ..< classifications.count, id: \.self) { index in
                        NavigationLink(destination: {
                            SessionDriverDetails(driverDetails: classifications[index])
                        }, label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    
                                    RoundedRectangle(cornerRadius: 120)
                                        .frame(width: 4.5, height: 30)
                                        .foregroundColor(getTeamColor(teamName: classifications[index].team))

                                    Text("\(classifications[index].position).  \(formatDriversName(name: classifications[index].name))")
                                        .padding(.leading, 6)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                            }
                        })
                    }
                }, header: {
                    HStack {
                        if finalStatus.count > 0 {
                            Text(finalStatus[0] == "FINISHED" ? "RESULTS" : "CLASSIFICATIONS")
                            Spacer()
                        }
                    }
                })
            }
            .navigationTitle(Text(eventTitle))
            .navigationBarTitleDisplayMode(.inline)
        }
        else {
            Text("Driver standings can not be shown at this time. Try again shortly.")
                .multilineTextAlignment(.center)
        }
    }
}

struct Session_Previews: PreviewProvider {
    static var previews: some View {
        SessionGrid(classifications: [driverDetailsForSession], eventTitle: "Sprint", status: [], index: 0, eventIsOccuring: "1")
    }
}
