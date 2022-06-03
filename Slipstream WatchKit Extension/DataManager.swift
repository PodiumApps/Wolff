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

struct GeneralData: Codable {
    var seasonSchedule: SeasonSchedule
    var seasonScheduleCurrentEvent: [Event]
    var seasonScheduleUpcomingEvents: [Event]
    var seasonSchedulePastEvents: [Event]
    var driverStandings: [Driver]
    var teamStandings: [Team]
    
    enum CodingKeys: String, CodingKey {
        case driverStandings = "driverStandings"
        case seasonScheduleCurrentEvent = "seasonScheduleCurrent"
        case seasonScheduleUpcomingEvents = "seasonScheduleUpcoming"
        case seasonSchedulePastEvents = "seasonSchedulePast"
        case teamStandings = "teamStandings"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        driverStandings = try container.decodeIfPresent([Driver].self, forKey: .driverStandings) ?? []
        teamStandings = try container.decodeIfPresent([Team].self, forKey: .teamStandings) ?? []
        seasonScheduleCurrentEvent = try container.decodeIfPresent([Event].self, forKey: .seasonScheduleCurrentEvent) ?? []
        seasonScheduleUpcomingEvents = try container.decodeIfPresent([Event].self, forKey: .seasonScheduleUpcomingEvents) ?? []
        seasonSchedulePastEvents = try container.decodeIfPresent([Event].self, forKey: .seasonSchedulePastEvents) ?? []
        seasonSchedule = SeasonSchedule(currentEvent: seasonScheduleCurrentEvent, upcomoingEvents: seasonScheduleUpcomingEvents, pastEvents: seasonSchedulePastEvents)
    }
}

struct NewsData: Codable {
    var news: [NewsArticle]
    
    enum CodingKeys: String, CodingKey {
        case news = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        news = try container.decodeIfPresent([NewsArticle].self, forKey: .news) ?? []
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
    
    @Published var generalData: GeneralData? = nil
    @Published var newsData: [NewsArticle]? = nil
    @Published var sessionsData: [Session]? = nil
    
    let generalDataPath = "/general_data/data"
    lazy var generalDataDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/general_data/timestamp")
    var generalDataDBHandle: DatabaseHandle? = nil
    
    let newsDataPath = "/news/data"
    lazy var newsDataDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/news/timestamp")
    var newsDataDBHandle: DatabaseHandle? = nil
    
    let sessionsDataPath = "sessions/data"
    lazy var allSessionsDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/timestamp")
    var allSessionsDatabaseHandle: DatabaseHandle? = nil
    
    lazy var sessionsDatabseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/live_event_is_occuring")
    var sessionsDBHandle: DatabaseHandle? = nil
    
    lazy var currentLiveSessionDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/0")
    var currentLiveSessionDatabaseHandle: DatabaseHandle? = nil
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    
    init() {
        //loadLocalData()
        //startAppDataListener()
        //checkInternetConnection()
        
        startGeneralDataListener()
        startNewsDataListener()
    }
    
    private func checkInternetConnection() {
        monitor.pathUpdateHandler = { path in
            print(path.status)
            if path.status != .satisfied {
                print("No Internet connection.")
                DispatchQueue.main.async {
                    self.dataRetrivalStatus = .errorLoadingData
                    //self.stopAppDataListener()
                }
            }
            else {
                print("We have Internet connection.")
                //self.startAppDataListener()
            }
        }

        monitor.start(queue: queue)
    }
    
    private func loadLocalData(filename: String) {
        let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if directoryURLs.count > 0 {
            let url = directoryURLs[0].appendingPathComponent(filename)
            do {
                let data = try Data(contentsOf: url)
                
                switch filename {
                case "generalData.txt":
                    let dataDecoded = self.decodeGeneralData(data: data)
                    self.generalData = dataDecoded
                    print("General Data loaded from file")
                case "newsData.txt":
                    let dataDecoded = self.decodeNewsData(data: data)
                    self.newsData = dataDecoded
                case "sessionsData.txt":
                    let dataDecoded = self.decodeAllSessionsJSON(data: data)
                    self.sessionsData = dataDecoded
                default:
                    return
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveLocalData(filename: String) {
        let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if directoryURLs.count > 0 {
            let url = directoryURLs[0].appendingPathComponent(filename)
            do {
                
                switch filename {
                case "generalData.txt":
                    let encodedData = try JSONEncoder().encode(generalData)
                    try encodedData.write(to: url)
                    print("General Data saved to file")
                case "newsData.txt":
                    let encodedData = try JSONEncoder().encode(newsData)
                    try encodedData.write(to: url)
                    print("News Data saved to file")
                case "sessionsData.txt":
                    let encodedData = try JSONEncoder().encode(sessionsData)
                    try encodedData.write(to: url)
                    print("Sessions Data saved to file")
                default:
                    return
                }
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private func startSessionsDataListener() {
        
        sessionsDBHandle = self.sessionsDatabseReference.observe(DataEventType.value) { snapshot in
            if snapshot.exists() {
                if let liveSessionIsOccuring = snapshot.value as? String {
                    if liveSessionIsOccuring == "1" {
                        self.startLiveSessionOccuringListener()
                        //We have a live event happening
                        //Go get the latest session
                    }
                    else {
                        self.stopLiveSessionOccuringListener()
                        //No live event is happening
                        //Compara os timestamps
                        //getAllSessions() - if timestamp diferente do guardado
                    }
                }
            }
            
        }
    }
    
    private func startGeneralDataListener() {
        
        generalDataDBHandle = self.generalDataDatabaseReference.observe(DataEventType.value) { timestampSnapshot in
            print("Started general data listener")
            
            if timestampSnapshot.exists() {
                if let timestamp = timestampSnapshot.value as? String {
                    if let savedTimestamp = UserDefaults.standard.string(forKey: "generalDataTimestamp") {
                        if timestamp != savedTimestamp {
                            
                            //We have new general data
                            let generalDataRef = Database.database().reference()
                            generalDataRef.child(self.generalDataPath).getData(completion: { dataError, dataSnapshot in
                                guard dataError == nil else {
                                    print(dataError!.localizedDescription)
                                    return
                                }
                                
                                if let data = dataSnapshot?.value {
                                    
                                    do {
                                        let json = try JSONSerialization.data(withJSONObject: data)
                                        let decodedData = self.decodeGeneralData(data: json)
                                        
                                        if let generalData = decodedData {
                                            self.generalData = generalData
                                            self.saveLocalData(filename: "generalData.txt")
                                        }
                                    }
                                    catch let error {
                                        print(error.localizedDescription)
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    private func stopGeneralDataListener() {
        if generalDataDBHandle != nil {
            generalDataDatabaseReference.removeAllObservers()
            print("Stoped general data listener")
        }
    }
    
    private func decodeGeneralData(data: Data?) -> GeneralData? {
        if let data = data {
            let generalData = try? JSONDecoder().decode(GeneralData.self, from: data)
            return generalData
        }
        
        return nil
    }
    
    
    private func startNewsDataListener() {
        print("Started News data listener")
        
        newsDataDBHandle = self.newsDataDatabaseReference.observe(DataEventType.value) { timestampSnapshot in
            if timestampSnapshot.exists() {
                if let timestamp = timestampSnapshot.value as? String {
                    if let savedTimestamp = UserDefaults.standard.string(forKey: "newsDataTimestamp") {
                        if timestamp != savedTimestamp {
                            
                            //We have new News data
                            let newsDataRef = Database.database().reference()
                            newsDataRef.child(self.newsDataPath).getData(completion: { dataError, dataSnapshot in
                                
                                if dataError == nil {
                                    if let data = dataSnapshot?.value {
                                        do {
                                            let json = try JSONSerialization.data(withJSONObject: data)
                                            let decodedData = self.decodeNewsData(data: json)
                                            
                                            if let newsData = decodedData {
                                                self.newsData = newsData
                                                self.saveLocalData(filename: "newsData.txt")
                                            }
                                        }
                                        catch let error {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    private func stopNewsDataListener() {
        if newsDataDBHandle != nil {
            newsDataDatabaseReference.removeAllObservers()
            print("Stopped news data listener")
        }
    }
    
    private func decodeNewsData(data: Data?) -> [NewsArticle]? {
        if let data = data {
            let newsData = try? JSONDecoder().decode([NewsArticle].self, from: data)
            return newsData
        }
        
        return nil
    }
    
    func startLiveSessionOccuringListener() {
        print("Started live session occuring data listener")
        
        self.currentLiveSessionDatabaseHandle = self.currentLiveSessionDatabaseReference.observe(DataEventType.value) { sessionSnapshot in

            if sessionSnapshot.exists() {
                if let sessionData = sessionSnapshot.value {
                    
                    //Decode session data
                    do {
                        let json = try JSONSerialization.data(withJSONObject: sessionData)
                        let dataDecoded = self.decodeSessionJSON(data: json)

                        if let newSession = dataDecoded {
                            
                            if self.sessionsData != nil {
                                self.sessionsData!.sort(by: { $0.timestamp > $1.timestamp })
                                        
                                if self.sessionsData![0].eventTitle == newSession.eventTitle {
                                    self.appData?.sessions[0] = newSession
                                }
                                else {
                                    self.sessionsData!.append(newSession)
                                }
                            }
                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func getAllSessions() {
        //TODO!
        
        allSessionsDatabaseHandle = self.allSessionsDatabaseReference.observe(DataEventType.value) { timestampSnapshot in
            print("Started general data listener")
            
            if timestampSnapshot.exists() {
                if let timestamp = timestampSnapshot.value as? String {
                    if let savedTimestamp = UserDefaults.standard.string(forKey: "sessionsDataTimestamp") {
                        if timestamp != savedTimestamp {
                            
                            //We have new general data
                            let generalDataRef = Database.database().reference()
                            generalDataRef.child(self.sessionsDataPath).getData(completion: { dataError, dataSnapshot in
                                if dataError == nil {
                                    if let data = dataSnapshot?.value {
                                        do {
                                            let json = try JSONSerialization.data(withJSONObject: data)
                                            let decodedData = self.decodeAllSessionsJSON(data: json)
                                            
                                            if let sessionsData = decodedData {
                                                self.sessionsData = sessionsData
                                                self.saveLocalData(filename: "sessionsData.txt")
                                            }
                                        }
                                        catch let error {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    private func stopLiveSessionOccuringListener() {
        if self.currentLiveSessionDatabaseHandle != nil {
            self.currentLiveSessionDatabaseReference.removeAllObservers()
            print("Stop live session occuring data listener")
        }
    }
    
    private func decodeAllSessionsJSON(data: Data?) -> [Session]? {
        if let data = data {
            let sessionsData = try? JSONDecoder().decode([Session].self, from: data)
            return sessionsData
        }
        
        return nil
    }
    
    private func decodeSessionJSON(data: Data?) -> Session? {
            
        if let data = data {
            let session = try? JSONDecoder().decode(Session.self, from: data)
            return session
        }
        
        dataRetrivalStatus = .errorLoadingData
        
        return nil
    }
    
    func getCurrentDayOfTheWeek() -> Int {
        let date = Date()
        return Calendar.current.component(.weekday, from: date)
    }
}
