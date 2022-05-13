//
//  ContentView.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 21/03/2022.
//

import SwiftUI
import Firebase

struct AppEntryPoint: View {
    
    init() {
        FirebaseApp.configure()
    }
    
    @ObservedObject var dataManager = DataManager()
    
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
        else if dataManager.dataRetrievalStatus == 2 {
            Text("Failed to retrieve data...")
                .multilineTextAlignment(.center)
                .onAppear {
                    dataManager.startAppDataListener()
                }
                .onDisappear {
                    dataManager.stopAppDataListener()
                }
        }
        else if dataManager.dataRetrievalStatus == 1 {
            if let appData = dataManager.appData {
                TabView {
                    EventsList(sessions: appData.sessions, events: appData.seasonSchedule)
                    
                    NewsList(news: appData.latestNews)
                    
                    Standings(
                        teams: appData.teamStandings,
                        drivers: appData.driverStandings
                    )
                    
                    Settings(lastServerUpdate: appData.timestamp)
                }
                .onAppear {
                    dataManager.startAppDataListener()
                }
                .onDisappear {
                    dataManager.stopAppDataListener()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppEntryPoint()
    }
}
