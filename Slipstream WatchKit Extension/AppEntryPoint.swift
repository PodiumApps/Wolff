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
        if dataManager.dataRetrievalStatus == .dataLoaded {
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
                
            }
        }
    }
}
