import Foundation

struct Event: Decodable {
    
    typealias ID = String
    
    let id: ID
    let firstGrandPrix: Int
    let lapRecord: String
    let name: String
    let length: Double
    let raceDistance: Double
    let round: Int
    let sessions: [Session]
}

extension Event {

    enum Status {
        case upcoming(details: String)
        case current(title: String, details: String)
        case live(title: String, details: String)
        case finished(drivers: [DriverResult])
    }
}
