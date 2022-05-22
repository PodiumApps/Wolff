//
//  AppEntryPoint.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI
import Firebase

struct AppEntryPoint: View {
    
    @ObservedObject var dataManager = DataManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        if dataManager.dataRetrievalStatus == 0 {
            ProgressView("Retrieving data...")
                .onAppear {
                    dataManager.startAppDataListener()
                }
                .onDisappear {
                    dataManager.stopAppDataListener()
                }
        }
        else {
            if let appData = dataManager.appData {
                TabView {
                    EventsList(sessions: appData.sessions, events: appData.seasonSchedule)

                    NewsList(news: appData.latestNews)

                    Standings(
                        teams: appData.teamStandings,
                        drivers: appData.driverStandings
                    )

                    Preferences(lastServerUpdate: appData.timestamp)
                }
                .confirmationDialog(
                    "Failed to retrieve data from server. The data you are seeing is not the most current. Make sure you are connected to the Internet and try again later.",
                    isPresented: $dataManager.showModalAlert,
                    actions: {}
                )
                .onAppear {
                    dataManager.startAppDataListener()
                }
                .onDisappear {
                    dataManager.stopAppDataListener()
                }
            }
            else {
                VStack {
                    Spacer()
                    
                    Text("Failed to retrieve data from server. Make sure you are connected to the Internet and try again later.")
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                }
            }
        }
    }
}
