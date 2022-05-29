//
//  DataManager.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import Foundation
import FirebaseDatabase
import CoreText
import Network
import SwiftUI

struct AppData: Codable {
    var liveEventIsOccuring: String
    var seasonSchedule: SeasonSchedule
    var seasonScheduleCurrentEvent: [Event]
    var seasonScheduleUpcomingEvents: [Event]
    var seasonSchedulePastEvents: [Event]
    var driverStandings: [Driver]
    var teamStandings: [Team]
    var latestNews: [NewsArticle]
    var sessions: [Session]
    
    enum CodingKeys: String, CodingKey {
        case driverStandings = "driverStandings"
        case latestNews = "latestNews"
        case seasonScheduleCurrentEvent = "seasonScheduleCurrent"
        case seasonScheduleUpcomingEvents = "seasonScheduleUpcoming"
        case seasonSchedulePastEvents = "seasonSchedulePast"
        case teamStandings = "teamStandings"
        case sessions = "sessions"
        case liveEventIsOccuring = "liveEventIsOccuring"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        liveEventIsOccuring = try container.decodeIfPresent(String.self, forKey: .liveEventIsOccuring) ?? ""
        driverStandings = try container.decodeIfPresent([Driver].self, forKey: .driverStandings) ?? []
        teamStandings = try container.decodeIfPresent([Team].self, forKey: .teamStandings) ?? []
        seasonScheduleCurrentEvent = try container.decodeIfPresent([Event].self, forKey: .seasonScheduleCurrentEvent) ?? []
        seasonScheduleUpcomingEvents = try container.decodeIfPresent([Event].self, forKey: .seasonScheduleUpcomingEvents) ?? []
        seasonSchedulePastEvents = try container.decodeIfPresent([Event].self, forKey: .seasonSchedulePastEvents) ?? []
        seasonSchedule = SeasonSchedule(currentEvent: seasonScheduleCurrentEvent, upcomoingEvents: seasonScheduleUpcomingEvents, pastEvents: seasonSchedulePastEvents)
        latestNews = try container.decodeIfPresent([NewsArticle].self, forKey: .latestNews) ?? []
        sessions = try container.decodeIfPresent([Session].self, forKey: .sessions) ?? []
    }
}

class DataManager: ObservableObject {
    
    enum DataRetrievalStatus {
        case loadingData
        case dataLoaded
        case errorLoadingData
    }
    
    @Published var appData: AppData? = nil
    @Published var dataRetrivalStatus: DataRetrievalStatus = .loadingData
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    
    lazy var totalDataDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/appData")
    var totalDataDatabaseHandle: DatabaseHandle? = nil
    
    lazy var lastDataTimestamp: DatabaseReference = Database.database().reference().ref.child("/timestamp")
    var lastDataTimestampHandle: DatabaseHandle? = nil
    
    lazy var liveSessionOccuringDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/liveEventIsOccuring")
    var liveSessionOccuringDatabaseHandle: DatabaseHandle? = nil
    
    lazy var currentLiveSessionDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/0")
    var currentLiveSessionDatabaseHandle: DatabaseHandle? = nil
    
    init() {
        loadLocalData()
        startAppDataListener()
        //checkInternetConnection()
    }
    
    private func checkInternetConnection() {
        monitor.pathUpdateHandler = { path in
            print(path.status)
            if path.status != .satisfied {
                print("No Internet connection.")
                DispatchQueue.main.async {
                    self.dataRetrivalStatus = .errorLoadingData
                    self.stopAppDataListener()
                }
            }
            else {
                print("We have Internet connection.")
                self.startAppDataListener()
            }
        }

        monitor.start(queue: queue)
    }
    
    private func loadLocalData() {
        let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if directoryURLs.count > 0 {
            let url = directoryURLs[0].appendingPathComponent("data.txt")
            do {
                let data = try Data(contentsOf: url)
                
                let dataDecoded = self.decodeJSON(data: data)
                if let appData = dataDecoded {
                    self.appData = appData
                    self.dataRetrivalStatus = .dataLoaded
                    print("Data loaded from file.")
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveLocalData() {
        let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if directoryURLs.count > 0 {
            let url = directoryURLs[0].appendingPathComponent("data.txt")
            do {
                if let data = appData {
                    let encodedData = try JSONEncoder().encode(data)
                    try encodedData.write(to: url)
                    print("Data saved to file.")
                }
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func startAppDataListener() {
        print("Started live session occuring listener")
        
        //Check if live eventIsOn
        liveSessionOccuringDatabaseHandle = liveSessionOccuringDatabaseReference.observe(DataEventType.value) { snapshot in
            
            let dayOfTheWeek = self.getCurrentDayOfTheWeek()
            
            if dayOfTheWeek >= 6 || dayOfTheWeek <= 1 {
                if snapshot.exists() {
                    if let data = snapshot.value as? String {
                        if data == "1" {
                            
                            if self.appData == nil {
                                
                                self.startTotalDataListener()
                                self.dataRetrivalStatus = .loadingData
                            }
                            
                            //Live Event is on
                            if self.currentLiveSessionDatabaseHandle == nil {
                                self.startLiveSessionOccuringListener()
                            }
                        }
                        else {
                            //Live event not occuring
                            self.stopLiveSessionDataListener()
                            if self.currentLiveSessionDatabaseHandle == nil {
                                self.startTotalDataListener()
                            }
                        }
                        
                        if self.appData?.liveEventIsOccuring != nil {
                            self.appData?.liveEventIsOccuring = data
                        }
                    }
                }
            }
            else {
                self.stopLiveSessionDataListener()
                if self.totalDataDatabaseHandle == nil {
                    self.startTotalDataListener()
                }
            }
        }
    }
    
    func startLiveSessionOccuringListener() {
        print("Started live session data listener")
        self.currentLiveSessionDatabaseHandle = self.currentLiveSessionDatabaseReference.observe(DataEventType.value) { sessionSnapshot in

            if sessionSnapshot.exists() {
                if let sessionData = sessionSnapshot.value {
                    
                    //Decode session data
                    do {
                        let json = try JSONSerialization.data(withJSONObject: sessionData)
                        let dataDecoded = self.decodeSessionJSON(data: json)

                        if let newSession = dataDecoded {
                            print("Retrieved new session")
                            print(newSession)
                            
                            if self.appData != nil {
                                if self.appData?.sessions != nil {
                                    self.appData?.sessions.sort(by: { $0.timestamp > $1.timestamp })
                                    if (self.appData?.sessions.count)! > 0 {
                                        
                                        if self.appData?.sessions[0].eventTitle == newSession.eventTitle {
                                            self.appData?.sessions[0] = newSession
                                        }
                                        else {
                                            self.appData?.sessions.append(newSession)
                                        }
                                        
                                        print("We have new session data")
                                    }
                                }
                                else {
                                    self.appData?.sessions = [Session]()
                                    self.appData?.sessions.append(newSession)
                                    
                                    print("Added new session")
                                }
                            }
                            
                            self.saveLocalData()
                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
            }

        }
    }
    
    func startTotalDataListener() {
        
        var lastTotalDataDownload = UserDefaults.standard.object(forKey: "lastTotalDataDownload") as? Date
        
        if lastTotalDataDownload == nil {
            UserDefaults.standard.set(Date(), forKey: "lastTotalDataDownload")
            lastTotalDataDownload = UserDefaults.standard.object(forKey: "lastTotalDataDownload") as? Date
        }
        
        print("Started Total Data Listener")
        self.totalDataDatabaseHandle = self.totalDataDatabaseReference.observe(DataEventType.value) { allDataSnapshot in
            
            if allDataSnapshot.exists() {
                if let data = allDataSnapshot.value {

                    do {
                        let json = try JSONSerialization.data(withJSONObject: data)
                        let dataDecoded = self.decodeJSON(data: json)

                        if let newData = dataDecoded {
                            print("Downloaded all data")
                            self.appData = newData
                            self.saveLocalData()
                            
                            self.dataRetrivalStatus = .dataLoaded
                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    
                    if self.appData != nil {
                        if self.appData?.liveEventIsOccuring == "1" {
                            self.stopTotalDataListener()
                        }
                    }
                }
            }
        }
    }
    
    func stopAppDataListener() {
        
        if liveSessionOccuringDatabaseHandle != nil {
            liveSessionOccuringDatabaseReference.removeAllObservers()
        }
        
        stopTotalDataListener()
        stopLiveSessionDataListener()
        stopLiveSessionOccuringListener()
    }
    
    func stopLiveSessionOccuringListener() {
        print("Stopped live session occuring listener")
        if liveSessionOccuringDatabaseHandle != nil {
            currentLiveSessionDatabaseReference.removeAllObservers()
        }
    }
    
    func stopLiveSessionDataListener() {
        print("Stopped live session data listener")
        if currentLiveSessionDatabaseHandle != nil {
            currentLiveSessionDatabaseReference.removeAllObservers()
        }
    }
    
    func stopTotalDataListener() {
        print("Stopped total data listener")
        if totalDataDatabaseHandle != nil {
            totalDataDatabaseReference.removeAllObservers()
        }
    }
    
    func getCurrentDayOfTheWeek() -> Int {
        let date = Date()
        return Calendar.current.component(.weekday, from: date)
    }
    
    func decodeJSON(data: Data?) -> AppData? {
        
        if let data = data {
            let appDataDecoded = try? JSONDecoder().decode(AppData.self, from: data)
            return appDataDecoded
        }
        
        dataRetrivalStatus = .errorLoadingData
        
        return nil
    }
    
    func decodeSessionJSON(data: Data?) -> Session? {
            
        if let data = data {
            let session = try? JSONDecoder().decode(Session.self, from: data)
            return session
        }
        
        dataRetrivalStatus = .errorLoadingData
        
        return nil
    }
}
