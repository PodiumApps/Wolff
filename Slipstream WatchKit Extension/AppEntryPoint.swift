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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        if dataManager.dataRetrievalStatus == true || dataManager.sheetDismissedOnce == true {
            TabView {
                EventsList(
                    sessions: dataManager.sessionsData ?? [],
                    liveEventIsOccuring: dataManager.liveSessionIsOccuring,
                    events: dataManager.generalData?.seasonSchedule ?? SeasonSchedule(currentEvent: [], upcomoingEvents: [], pastEvents: [])
                )
                
                NewsList(news: dataManager.newsData ?? [])
                
                Standings(
                    teams: dataManager.generalData?.teamStandings ?? [],
                    drivers: dataManager.generalData?.driverStandings ?? []
                )
                
                Preferences()
            }
        }
        else {
            VStack {
                Spacer()
                Text("Check your Internet Connection")
                Spacer()
                Button("Dismiss") {
                    dataManager.sheetDismissedOnce = true
                }
            }
        }
    }
}
