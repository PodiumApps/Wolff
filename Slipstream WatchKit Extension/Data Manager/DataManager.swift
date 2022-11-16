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
    
    let sessionsDataPath = "/sessions/data/"
    lazy var allSessionsDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/timestamp")
    var allSessionsDatabaseHandle: DatabaseHandle? = nil
    
    let liveEventStatusDataPath = "/live_session_is_occuring/data"
    lazy var liveSessionStatusDatabseReference: DatabaseReference = Database.database().reference().ref.child("/live_session_is_occuring/data")
    var liveSessionOccuringDBHandle: DatabaseHandle? = nil
    
    lazy var currentLiveSessionDatabaseReference: DatabaseReference = Database.database().reference().ref.child("/sessions/data/0")
    var currentLiveSessionDatabaseHandle: DatabaseHandle? = nil
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    
    var timer = Timer()
    
    init() {
        loadLocalData(filename: "generalData.txt")
        loadLocalData(filename: "newsData.txt")
        loadLocalData(filename: "sessionsData.txt")
        
        // getGeneralData()
        // getNewsData()
        // getAllSessions()
//        getLiveSessionStatus()
        
        startTimer()
        
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

    
//    private func getLiveSessionStatus() {
//        startListener(
//            reference: liveSessionStatusDatabseReference,
//            handle: &liveSessionOccuringDBHandle,
//            timestampKey: nil,
//            dataPath: liveEventStatusDataPath
//        ) { (status: String) in
//            self.liveSessionIsOccuring = status
//
//            switch status {
//            case "1":
//                self.getLiveSessionData()
//            default: return
//            }
//        }
//    }
    
//    private func getLiveSessionData() {
//        startListener(
//            reference: currentLiveSessionDatabaseReference,
//            handle: &currentLiveSessionDatabaseHandle,
//            timestampKey: nil,
//            dataPath: nil
//        ) { (newSession: Session) in
//            guard self.sessionsData != nil else { return }
//            self.sessionsData?.sort(by: { $0.timestamp > $1.timestamp })
//
//            if self.sessionsData![0].eventTitle == newSession.eventTitle {
//                self.sessionsData![0] = newSession
//            }
//            else {
//                self.sessionsData!.append(newSession)
//            }
//        }
//    }
    
//    private func getAllSessions() {
//        startListener(
//            reference: allSessionsDatabaseReference,
//            handle: &allSessionsDatabaseHandle,
//            timestampKey: "sessionsDataTimestamp",
//            dataPath: sessionsDataPath
//        ) { (sessionsData: [Session]) in
//            self.sessionsData = sessionsData
//            self.saveLocalData(filename: "sessionsData.txt")
//        }
//    }
    
    func startTimer() {
        
        let generalDataTimestampURL = "https://slipstream-76796-default-rtdb.firebaseio.com/general_data/timestamp.json"
        let generalDataTimestampKey = "generalDataTimestamp"
        
        let newsDataTimestampURL = "https://slipstream-76796-default-rtdb.firebaseio.com/news/timestamp.json"
        let newsDataTimestampKey = "newsDataTimestamp"
        
        let liveEventIsOccuringURL = "https://slipstream-76796-default-rtdb.firebaseio.com/live_session_is_occuring/data.json"
        
        let allSessionsDataTimestampURL = "https://slipstream-76796-default-rtdb.firebaseio.com/sessions/timestamp.json"
        let allSessionsTimestampKey = "sessionsDataTimestamp"
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            
            // General Data
            URLSession.shared.dataTask(with: URL(string: generalDataTimestampURL)!) { data, _, error in
                
                guard let data = data, error == nil else { fatalError("General Data timestamp not found!") }
                let generalDataTimestamp = String(decoding: data, as: UTF8.self)
                
                if generalDataTimestamp != UserDefaults.standard.string(forKey: generalDataTimestampKey) {
                    UserDefaults.standard.set(generalDataTimestamp, forKey: generalDataTimestampKey)
                    
                    let dataURL = "https://slipstream-76796-default-rtdb.firebaseio.com/general_data/data.json"
                    self.getDataFromURL(dataURL: dataURL) { (generalData: GeneralData) in
                        self.generalData = generalData
                        self.saveLocalData(filename: "generalData.txt")
                    }
                }
                
            }.resume()
            
            // News Data
            URLSession.shared.dataTask(with: URL(string: newsDataTimestampURL)!) { data, _, error in
                
                guard let data = data, error == nil else { fatalError("News data timestamp not found!") }
                let newsDataTimestamp = String(decoding: data, as: UTF8.self)
                
                if newsDataTimestamp != UserDefaults.standard.string(forKey: newsDataTimestampKey) {
                    UserDefaults.standard.set(newsDataTimestamp, forKey: newsDataTimestampKey)
                    
                    let dataURL = "https://slipstream-76796-default-rtdb.firebaseio.com/news/data.json"
                    self.getDataFromURL(dataURL: dataURL) { (newsData: [NewsArticle]) in
                        self.newsData = newsData
                        self.saveLocalData(filename: "newsData.txt")
                    }
                }
            }.resume()
            
            // Live Event Is Occuring
            URLSession.shared.dataTask(with: URL(string: liveEventIsOccuringURL)!) { data, _, error in
                
                guard let data = data, error == nil else { fatalError("Live Session Is Occuring data not found!") }
                let liveSessionIsOccuring = String(decoding: data, as: UTF8.self)
                self.liveSessionIsOccuring = liveSessionIsOccuring
                print(self.liveSessionIsOccuring)
            }.resume()
            
            if self.liveSessionIsOccuring == "0" {
                
            }
            else if self.liveSessionIsOccuring == "1" {
                
            }
        }
    }
    
    private func getDataFromURL<T: Decodable>(
        dataURL: String?,
        saveData: @escaping (T) -> Void
    ) {
        
        func save(_ data: Data?) {
            guard let data = data else { return }
            
            do {
                saveData(try JSONDecoder().decode(T.self, from: data))
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        guard let dataURL = dataURL else { fatalError("Data URL not available.") }
        
        URLSession.shared.dataTask(with: URL(string: dataURL)!) { data, _, error in
            
            guard let generalData = data, error == nil else { fatalError("General Data not found!") }
            save(generalData)
        }.resume()
    }
}
