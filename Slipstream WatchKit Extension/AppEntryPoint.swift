//
//  AppEntryPoint.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI
import Firebase

struct AppEntryPoint: View {
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        if let appData = dataManager.appData {
            TabView {
                EventsList(
                    sessions: appData.sessions,
                    liveEventIsOccuring: appData.liveEventIsOccuring,
                    events: appData.seasonSchedule
                )

                NewsList(news: appData.latestNews)

                Standings(
                    teams: appData.teamStandings,
                    drivers: appData.driverStandings
                )

                Preferences()
            }
            .confirmationDialog(
                "Failed to retrieve data from server. The data has not been updated. Make sure you are connected to the Internet and try again.",
                isPresented: $dataManager.dataNotUpdated,
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

                Text("Failed to retrieve data from server. Make sure you are connected to the Internet and try again later.")
                    .font(.caption2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()

                Button("Reconnect") {
                    dataManager.startAppDataListener()
                }
            }
        }
    }
}
