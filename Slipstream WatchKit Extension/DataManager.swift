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

class DataManager: ObservableObject {
    
    enum DataRetrievalStatus {
        case loadingData
        case dataLoaded
        case errorLoadingData
    }
    
    @Published var generalData: GeneralData?
    @Published var newsData: [NewsArticle]?
    @Published var sessionsData: [Session]?
    @Published var liveSessionIsOccuring = "0"
    
    let generalDataPath = "/general_data/data"
    lazy var generalDataDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/general_data/timestamp")
    var generalDataDBHandle: DatabaseHandle? = nil
    
    let newsDataPath = "/news/data"
    lazy var newsDataDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/news/timestamp")
    var newsDataDBHandle: DatabaseHandle? = nil
    
    let sessionsDataPath = "sessions/data"
    lazy var allSessionsDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/timestamp")
    var allSessionsDatabaseHandle: DatabaseHandle? = nil
    
    lazy var liveSessionOccuringDatabseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/live_event_is_occuring")
    var liveSessionOccuringDBHandle: DatabaseHandle? = nil
    
    lazy var currentLiveSessionDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/0")
    var currentLiveSessionDatabaseHandle: DatabaseHandle? = nil
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    
    init() {
        loadLocalData(filename: "generalData.txt")
        loadLocalData(filename: "newsData.txt")
        loadLocalData(filename: "sessionsData.txt")
        
        startLiveSessionsTimestampDataListener()
        startGeneralDataListener()
        startNewsDataListener()
    }
    
    private func checkInternetConnection() {
        monitor.pathUpdateHandler = { path in
            print(path.status)
            if path.status != .satisfied {
                print("No Internet connection.")
                DispatchQueue.main.async {
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
                    print("News Data loaded from file")
                case "sessionsData.txt":
                    let dataDecoded = self.decodeAllSessionsJSON(data: data)
                    self.sessionsData = dataDecoded
                    print("Sessions Data loaded from file")
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
    
    private func startLiveSessionsTimestampDataListener() {
        
        print("Start Live Session Timestamp Data Listener")
        
        liveSessionOccuringDBHandle = self.liveSessionOccuringDatabseReference.observe(DataEventType.value) { snapshot in
            if snapshot.exists() {
                if let liveSessionIsOccuring = snapshot.value as? String {
                    self.liveSessionIsOccuring = liveSessionIsOccuring
                    
                    if liveSessionIsOccuring == "1" {
                        self.startLiveSessionIsOccuring()
                        //We have a live event happening
                        //Go get the latest session
                    }
                    else {
                        self.stopLiveSessionIsOccuring()
                        self.getAllSessions()
                        //No live event is happening
                    }
                }
            }
            
        }
    }
    
    private func stopLiveSessionsTimestampDataListener() {
        if liveSessionOccuringDBHandle != nil {
            liveSessionOccuringDatabseReference.removeAllObservers()
            print("Start Live Session Timestamp Data Listener")
        }
    }
    
    private func startGeneralDataListener() {
        print("Started general data listener")
        
        generalDataDBHandle = self.generalDataDatabaseReference.observe(DataEventType.value) { timestampSnapshot in
            
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
                                            UserDefaults.standard.set(timestamp, forKey: "generalDataTimestamp")
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
                                                UserDefaults.standard.set(timestamp, forKey: "newsDataTimestamp")
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
    
    func startLiveSessionIsOccuring() {
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
                                    //self.appData?.sessions[0] = newSession
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
        
        print("Started all sessions data listener")
        
        allSessionsDatabaseHandle = self.allSessionsDatabaseReference.observe(DataEventType.value) { timestampSnapshot in
            
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
                                                UserDefaults.standard.set(timestamp, forKey: "sessionsDataTimestamp")
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
    
    private func stopLiveSessionIsOccuring() {
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
        
        return nil
    }
}
