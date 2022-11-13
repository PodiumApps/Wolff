import Foundation
import FirebaseDatabase
import Firebase
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
    lazy var newsDataDatabaseReference: DatabaseReference =
        Database.database().reference().ref.child("/news/timestamp")
    var newsDataDBHandle: DatabaseHandle? = nil
    
    let sessionsDataPath = "/sessions/data/sessions"
    lazy var allSessionsDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/timestamp")
    var allSessionsDatabaseHandle: DatabaseHandle? = nil
    
    let liveEventStatusDataPath = "/sessions/live_event_is_occuring"
    lazy var liveSessionStatusDatabseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/live_event_is_occuring")
    var liveSessionOccuringDBHandle: DatabaseHandle? = nil
    
    lazy var currentLiveSessionDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/data/sessions/0")
    var currentLiveSessionDatabaseHandle: DatabaseHandle? = nil
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    
    init() {
        loadLocalData(filename: "generalData.txt")
        loadLocalData(filename: "newsData.txt")
        loadLocalData(filename: "sessionsData.txt")
        
        getGeneralData()
        getNewsData()
        getAllSessions()
        getLiveSessionStatus()
        
        checkInternetConnection()
    }
    
    private func checkInternetConnection() {
        monitor.pathUpdateHandler = { path in
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
                    self.generalData = dataDecoder(data: data)
                    print("General Data loaded from file")
                case "newsData.txt":
                    self.newsData = dataDecoder(data: data)
                    print("News Data loaded from file")
                case "sessionsData.txt":
                    self.sessionsData = dataDecoder(data: data)
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
    
    private func dataDecoder<T: Decodable>(
        data: Data
    ) -> T? {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        
        return decodedData
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
    
    private func getNewsData() {
        startListener(
            reference: newsDataDatabaseReference,
            handle: &newsDataDBHandle,
            timestampKey: "newsDataTimestamp",
            dataPath: newsDataPath
        ) { (newsData: [NewsArticle]) in
            self.newsData = newsData
            self.saveLocalData(filename: "newsData.txt")
        }
    }
    
    
    private func getGeneralData() {
        startListener(
            reference: generalDataDatabaseReference,
            handle: &generalDataDBHandle,
            timestampKey: "generalDataTimestamp",
            dataPath: generalDataPath
        ) { (generalData: GeneralData) in
            self.generalData = generalData
            self.saveLocalData(filename: "generalData.txt")
        }
    }
    
    private func getLiveSessionStatus() {
        startListener(
            reference: liveSessionStatusDatabseReference,
            handle: &liveSessionOccuringDBHandle,
            timestampKey: nil,
            dataPath: liveEventStatusDataPath
        ) { (status: String) in
            self.liveSessionIsOccuring = status
            
            switch status {
            case "1":
                self.getLiveSessionData()
            default: return
            }
        }
    }
    
    private func getLiveSessionData() {
        startListener(
            reference: currentLiveSessionDatabaseReference,
            handle: &currentLiveSessionDatabaseHandle,
            timestampKey: nil,
            dataPath: nil
        ) { (newSession: Session) in
            guard self.sessionsData != nil else { return }
            self.sessionsData?.sort(by: { $0.timestamp > $1.timestamp })
            
            if self.sessionsData![0].eventTitle == newSession.eventTitle {
                self.sessionsData![0] = newSession
            }
            else {
                self.sessionsData!.append(newSession)
            }
        }
    }
    
    private func getAllSessions() {
        startListener(
            reference: allSessionsDatabaseReference,
            handle: &allSessionsDatabaseHandle,
            timestampKey: "sessionsDataTimestamp",
            dataPath: sessionsDataPath
        ) { (sessionsData: [Session]) in
            self.sessionsData = sessionsData
            self.saveLocalData(filename: "sessionsData.txt")
        }
    }
    
    private func startListener<T: Decodable>(
        reference: DatabaseReference,
        handle: inout DatabaseHandle?,
        timestampKey: String?,
        dataPath: String?,
        saveData: @escaping (T) -> Void
    ) {
        
        func save(_ snapshot: DataSnapshot?) {
            guard let data = snapshot?.value else { return }
            
            if dataPath == liveEventStatusDataPath {
                saveData(data as! T)
            }
            else {
                do {
                    let json = try JSONSerialization.data(withJSONObject: data)
                    saveData(try JSONDecoder().decode(T.self, from: json))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        handle = reference.observe(DataEventType.value) { sessionSnapshot in
            
            guard sessionSnapshot.exists() else { return }
            guard let dataPath = dataPath else { return }
            
            
            if let timestampKey = timestampKey {
                guard let timestamp = sessionSnapshot.value as? String,
                      timestamp != UserDefaults.standard.string(forKey: timestampKey)
                else { return }
                UserDefaults.standard.set(timestamp, forKey: timestampKey)
            }
            
            Database
                .database()
                .reference()
                .child(dataPath)
                .getData(
                    completion: { dataError, dataSnapshot in
                        guard dataError == nil else { return }
                        save(dataSnapshot)
                    }
                )
        }
    }
}
