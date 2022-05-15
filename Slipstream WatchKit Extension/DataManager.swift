//
//  Firebase.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 30/03/2022.
//

import Foundation
import FirebaseDatabase
import CoreText
//import UserNotifications

struct AppData: Codable {
    var timestamp: String
    var seasonSchedule: SeasonSchedule
    var driverStandings: [Driver]
    var teamStandings: [Team]
    var latestNews: [NewsArticle]
    var sessions: [Session]
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "timestamp"
        case driverStandings = "driverStandings"
        case latestNews = "latestNews"
        case seasonSchedule = "seasonSchedule"
        case teamStandings = "teamStandings"
        case sessions = "sessions"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
        driverStandings = try container.decodeIfPresent([Driver].self, forKey: .driverStandings) ?? []
        teamStandings = try container.decodeIfPresent([Team].self, forKey: .teamStandings) ?? []
        seasonSchedule = try container.decodeIfPresent(SeasonSchedule.self, forKey: .seasonSchedule) ?? SeasonSchedule(currentEvent: [], upcomoingEvents: [], pastEvents: [])
        latestNews = try container.decodeIfPresent([NewsArticle].self, forKey: .latestNews) ?? []
        sessions = try container.decodeIfPresent([Session].self, forKey: .sessions) ?? []
    }
}

class DataManager: ObservableObject {
    
    @Published var appData: AppData?
    @Published var dataRetrievalStatus = 0
    
    lazy var databaseReference: DatabaseReference = Database.database().reference().ref.child("/")
    var databaseHandle: DatabaseHandle?
    
    init() {
        self.loadLocalData()
        if self.appData != nil {
            dataRetrievalStatus = 1
        }
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

        databaseHandle = databaseReference.observe(DataEventType.value, with: { snapshop in
            if snapshop.exists() {
                if let data = snapshop.value {
                    
                    self.dataRetrievalStatus = 0
                    
                    do {
                        let json = try JSONSerialization.data(withJSONObject: data)
                        let dataDecoded = self.decodeJSON(data: json)
                        
                        if let newData = dataDecoded {
                            
                            if self.appData != nil {
                                print("Checking for notifications")
                            }
                            else {
                                print("Could not check for notifications because local app data does not exist.")
                            }
                            
                            self.appData = newData
                            self.saveLocalData()
                            
                            self.dataRetrievalStatus = 1
                        }
                        else {
                            self.dataRetrievalStatus = 2
                        }
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
            else {
                self.dataRetrievalStatus = 2
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
    
    func decodeJSON(data: Data?) -> AppData? {
        
        if let data = data {
            let appDataDecoded = try? JSONDecoder().decode(AppData.self, from: data)
            return appDataDecoded
        }
        
        return nil
    }
}