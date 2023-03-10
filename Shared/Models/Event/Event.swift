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
    
    var status: Status {
        
        let formatter = DateFormatter()
        
        guard
            let firstSessionDate: Date = sessions.first?.date,
            let finalSessionDate: Date = sessions.last?.date
        else {
            fatalError("There should have an interval date for event id -> \(id)")
        }
        
        if sessions.filter({ $0.winnerID != nil }).count == sessions.count  {
            return .finished(
                drivers: [
                    .init(
                        driverTicker: sessions.first(where: { $0.name == .race })?.winnerID ?? "",
                        value: .first
                    )
                ]
            )
        }
        
        formatter.dateFormat = "dd"
        
        let firstDay = formatter.string(from: firstSessionDate)
        let lastDay = formatter.string(from: finalSessionDate)
        
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: finalSessionDate).uppercased()
        
        return .upcoming(details: "\(firstDay) - \(lastDay) \(month)")
    }

    enum Status {
        case upcoming(details: String)
        case current(title: String, details: String)
        case live(title: String, details: String)
        case finished(drivers: [DriverResult])
    }
}


extension Event {
    
    static func getEvents() -> Resource<[Self]> {

        guard let url = URL(string: "\(Global.url)/v1/events") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}
