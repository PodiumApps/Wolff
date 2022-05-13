//
//  Session.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 22/04/2022.
//

import SwiftUI

struct SessionGrid: View {
    
    var classifications: [DriverDetailsForSession]
    var eventTitle: String
    var status: [String]
    
    var body: some View {
        
        if classifications.count > 0 {
        
            GeometryReader { geometry in
                
                ScrollView {
                        
                    ForEach(0 ..< status.count, id: \.self) { index in
                        if status[index] != "" {
                            HStack {
                                Text(status[index])
                                Spacer()
                            }
                            .padding(.leading)
                        }
                        
                    }
                    
                    Divider()
                        .padding()
                    
                    Section(content: {
                        ForEach(0 ..< classifications.count, id: \.self) { index in
                            NavigationLink(destination: {
                                SessionDriverDetails(driverDetails: classifications[index])
                            }, label: {
                                VStack(alignment: .leading) {
                                    
                                    HStack {
                                        
                                        RoundedRectangle(cornerRadius: 120)
                                            .frame(width: 4.5, height: 34)
                                            .foregroundColor(getTeamColor(teamName: classifications[index].team))

                                        Text("\(classifications[index].position).  \(formatDriversName(name: classifications[index].name))")
                                            .padding(.leading, 6)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                }
                                .frame(height: geometry.size.height / 100, alignment: .center)
                            })
                        }
                    }, header: {
                        HStack {
                            if status.count > 0 {
                                Text(status[0] == "FINISHED" ? "RESULTS" : "CLASSIFICATIONS")
                                Spacer()
                            }
                        }
                        .padding(.leading)
                    })
                }
                .navigationTitle(Text(eventTitle))
                .navigationBarTitleDisplayMode(.inline)
                .padding(.top)
            }
        }
        else {
            Text("Driver standings can not be shown at this time. Try again shortly.")
                .multilineTextAlignment(.center)
        }
    }
}

struct Session_Previews: PreviewProvider {
    static var previews: some View {
        SessionGrid(classifications: [driverDetailsForSession], eventTitle: "Sprint", status: [])
    }
}
