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
        case error
    }
    
    @Published var generalData: GeneralData?
    @Published var newsData: [NewsArticle]?
    @Published var sessionsData: [Session]?
    @Published var liveSessionIsOccuring = "0"
    @Published var dataRetrievalStatus = DataRetrievalStatus.dataLoaded
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    
    var timer = Timer()
    
    init() {
        loadLocalData(filename: "generalData.txt")
        loadLocalData(filename: "newsData.txt")
        loadLocalData(filename: "sessionsData.txt")
        
        fetchData()
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
    
    private func fetchGeneralData() {
        
        let generalDataTimestampURL = "https://slipstream-76796-default-rtdb.firebaseio.com/general_data/timestamp.json"
        let generalDataTimestampKey = "generalDataTimestamp"
        
        // General Data
        URLSession.shared.dataTask(with: URL(string: generalDataTimestampURL)!) { data, _, error in
            
            guard let data = data, error == nil else {
                print("General Data timestamp not found!")
                self.dataRetrievalStatus = .error
                return
            }
            
            self.dataRetrievalStatus = .dataLoaded
            
            let generalDataTimestamp = String(decoding: data, as: UTF8.self)
            
            if generalDataTimestamp != UserDefaults.standard.string(forKey: generalDataTimestampKey) {
                UserDefaults.standard.set(generalDataTimestamp, forKey: generalDataTimestampKey)
                
                let dataURL = "https://slipstream-76796-default-rtdb.firebaseio.com/general_data/data.json"
                self.getDataFromURL(dataURL: dataURL) { (generalData: GeneralData) in
                    DispatchQueue.main.async {
                        self.generalData = generalData
                        self.saveLocalData(filename: "generalData.txt")
                    }
                }
            }
            
        }.resume()
    }
    
    private func fetchNewsData() {
        
        let newsDataTimestampURL = "https://slipstream-76796-default-rtdb.firebaseio.com/news/timestamp.json"
        let newsDataTimestampKey = "newsDataTimestamp"
        
        // News Data
        URLSession.shared.dataTask(with: URL(string: newsDataTimestampURL)!) { data, _, error in
            
            guard let data = data, error == nil else {
                print("News data timestamp not found!")
                self.dataRetrievalStatus = .error
                return
            }
            
            self.dataRetrievalStatus = .dataLoaded
            
            let newsDataTimestamp = String(decoding: data, as: UTF8.self)
            
            if newsDataTimestamp != UserDefaults.standard.string(forKey: newsDataTimestampKey) {
                UserDefaults.standard.set(newsDataTimestamp, forKey: newsDataTimestampKey)
                
                let dataURL = "https://slipstream-76796-default-rtdb.firebaseio.com/news/data.json"
                self.getDataFromURL(dataURL: dataURL) { (newsData: [NewsArticle]) in
                    DispatchQueue.main.async {
                        self.newsData = newsData
                        self.saveLocalData(filename: "newsData.txt")
                    }
                }
            }
        }.resume()
    }
    
    private func fetchSessionsData() {
        
        let liveEventIsOccuringURL = "https://slipstream-76796-default-rtdb.firebaseio.com/live_session_is_occuring/data.json"
        
        let allSessionsDataTimestampURL = "https://slipstream-76796-default-rtdb.firebaseio.com/sessions/timestamp.json"
        let allSessionsTimestampKey = "sessionsDataTimestamp"
        
        // Live Event Is Occuring
        URLSession.shared.dataTask(with: URL(string: liveEventIsOccuringURL)!) { data, _, error in
            
            guard let data = data, error == nil else {
                print("Live Session Is Occuring data not found!")
                self.dataRetrievalStatus = .error
                return
            }
            
            self.dataRetrievalStatus = .dataLoaded
            
            let liveSessionIsOccuring = String(data: data, encoding: .utf8)
            
            DispatchQueue.main.async {
                self.liveSessionIsOccuring = liveSessionIsOccuring ?? "0"
            }
        }.resume()
        
        if self.liveSessionIsOccuring == "0" || self.liveSessionIsOccuring == "\"0\"" {
            
            // All sessions data
            URLSession.shared.dataTask(with: URL(string: allSessionsDataTimestampURL)!) { data, _, error in
                
                guard let data = data, error == nil else {
                    print("Sessions data not found")
                    self.dataRetrievalStatus = .error
                    return
                }
                
                self.dataRetrievalStatus = .dataLoaded
                
                let sessionsDataTimestamp = String(decoding: data, as: UTF8.self)
                
                if sessionsDataTimestamp != UserDefaults.standard.string(forKey: allSessionsTimestampKey) {
                    UserDefaults.standard.set(sessionsDataTimestamp, forKey: allSessionsTimestampKey)
                    
                    let dataURL = "https://slipstream-76796-default-rtdb.firebaseio.com/sessions/data.json"
                    self.getDataFromURL(dataURL: dataURL) { (sessionsData: [Session]) in
                        DispatchQueue.main.async {
                            self.sessionsData = sessionsData
                            self.saveLocalData(filename: "sessionsData.txt")
                        }
                    }
                }
            }.resume()
        }
        else if self.liveSessionIsOccuring == "1" || self.liveSessionIsOccuring == "\"1\"" {
            
            // Latest live session
            let dataURL = "https://slipstream-76796-default-rtdb.firebaseio.com/sessions/data/0.json"
            self.getDataFromURL(dataURL: dataURL) { (newSession: Session) in
                DispatchQueue.main.async {
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
        }
    }
    
    private func fetchData() {
        
        DispatchQueue.main.async {
            self.fetchGeneralData()
            self.fetchNewsData()
            self.fetchSessionsData()
        }
    }
    
    func startTimer() {
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.fetchData()
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
        
        guard let dataURL = dataURL else { print("Data URL not available."); return }
        
        URLSession.shared.dataTask(with: URL(string: dataURL)!) { data, _, error in
            
            guard let data = data, error == nil else { print("Data not found"); return }
            
            self.dataRetrievalStatus = .dataLoaded
            save(data)
        }.resume()
    }
}
