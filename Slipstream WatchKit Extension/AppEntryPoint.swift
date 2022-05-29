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
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        TabView {
            switch dataManager.dataRetrivalStatus {
            case .loadingData:
                ProgressView("Loading data...")
            case .dataLoaded:
                if let appData = dataManager.appData {
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
            case .errorLoadingData:
                VStack {
                    
                    Spacer()

                    Text("Failed to retrieve data from server. Make sure you are connected to the Internet and try again later.")
                        .font(.caption2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()

                    Spacer()
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase != .active {
                dataManager.stopAppDataListener()
                print("Stop app data listener")
            }
            else {
                dataManager.startAppDataListener()
                print("Start app data listener")
            }
        }
    }
}
