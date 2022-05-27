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

struct AppData: Codable {
    var timestamp: String
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
        case timestamp = "timestamp"
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
        timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
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
    
    @Published var appData: AppData? = nil
    @Published var dataNotUpdated = false
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    
    lazy var databaseReference: DatabaseReference = Database.database().reference().ref.child("/")
    var databaseHandle: DatabaseHandle? = nil
    
    init() {
        loadLocalData()
        
        monitor.pathUpdateHandler = { path in
            print(path.status)
            if path.status != .unsatisfied {
                print("No Internet connection.")
                if self.appData != nil {
                    DispatchQueue.main.async {
                        self.dataNotUpdated = true
                    }
                }
            }
            else {
                print("We have Internet connection.")
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
        
        print(getCurrentDayOfTheWeek())
        
        let dayOfTheWeek = getCurrentDayOfTheWeek()
        
        
        

        databaseHandle = databaseReference.observe(DataEventType.value, with: { snapshop in
            
            if snapshop.exists() {
                if let data = snapshop.value {
                    
                    do {
                        let json = try JSONSerialization.data(withJSONObject: data)
                        let dataDecoded = self.decodeJSON(data: json)
                        
                        print("Retrieved data!")
                        
                        if let newData = dataDecoded {
                            
                            self.appData = newData
                            self.saveLocalData()
                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        })
    }
    
    func stopAppDataListener() {
        if databaseHandle != nil {
            if let databaseHandle = databaseHandle {
                databaseReference.removeObserver(withHandle: databaseHandle)
            }
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
        
        return nil
    }
}
