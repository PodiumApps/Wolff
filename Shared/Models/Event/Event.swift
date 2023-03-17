import Foundation

struct Event: Decodable {
    
    typealias ID = Identifier<Event>
    
    let id: ID
    let firstGrandPrix: Int
    let lapRecord: String
    let name: String
    let title: String
    let country: String
    let length: Double
    let raceDistance: Double
    let round: Int
    let sessions: [Session]
}

extension Event {
    
    var shortDetails: ShortDetails {
        .init(status: status, round: round, title: title, country: country)
    }

    var status: Status {
        
        if let nextSession = sessions.first(where: {
            $0.date.timeIntervalSince(Date()) > -.maximumSessionTime
            && $0.date.timeIntervalSince(Date()) < .maximumSessionTime
            && $0.winners.isEmpty
        }) {
            
            return .live(timeInterval: nextSession.date.timeIntervalSinceNow, sessionName: nextSession.name.label)
        }
        
        if
            sessions.lazy.filter({ !$0.winners.isEmpty }).count == sessions.count,
            let winners = sessions.lazy.first(where: { $0.name == .race })?.winners
        {
            
            return .finished(winner: winners)
        }
        
        if let session = sessions.lazy.first(where: {
            $0.winners.isEmpty
            && $0.date.timeIntervalSince(Date()) < .threeDaysInterval
        }){
            return .upcoming(
                start: daysString.first,
                end: daysString.last,
                sessionName: session.name.label,
                timeInterval: session.date.timeIntervalSinceNow
            )
        }
        
        return .upcoming(
            start: daysString.first,
            end: daysString.last,
            sessionName: "",
            timeInterval: nil
        )

    }
    
    var daysString: (first: String, last: String) {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_us")
        
        guard
            let firstSessionDate: Date = sessions.first?.date,
            let finalSessionDate: Date = sessions.last?.date
        else {
            fatalError("There should have an interval date for event id -> \(id)")
        }
        
        formatter.dateFormat = "MMMM"
        let firstMonth = formatter.string(from: firstSessionDate).uppercased()
        let lastMonth = formatter.string(from: finalSessionDate).uppercased()
        
        formatter.dateFormat = "dd"
        
        let firstDay = formatter.string(from: firstSessionDate) + (firstMonth == lastMonth ? "" : " " + firstMonth)
        let lastDay = formatter.string(from: finalSessionDate) + " " + lastMonth
        
        return (first: firstDay, last: lastDay)
    }

    enum Status: Equatable {
        
        case upcoming(start: String, end: String, sessionName: String, timeInterval: TimeInterval? = nil)
        case live(timeInterval: TimeInterval, sessionName: String)
        case finished(winner: [Driver.ID])
        
        
        enum idValue: String {
            case live = "live"
            case upcoming = "upcoming"
            case finished = "finished"
        }
        
        var id: String {
            
            switch self {
            case .upcoming: return idValue.upcoming.rawValue
            case .live: return idValue.live.rawValue
            case .finished: return idValue.finished.rawValue
            }
        }
    }
}


extension Event {
    
    static func getEvents() -> Resource<[Self]> {

        guard let url = URL(string: "\(Global.url)/v1/events") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
    
    static func getNextEvent() -> Resource<Self> {

        guard let url = URL(string: "\(Global.url)/v1/events/next") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}

extension Event {
    
    struct ShortDetails {
        
        let status: Status
        let round: Int
        let title: String
        let country: String
    }
    
    static let mockStatusUpcoming: Event.Status = .upcoming(start: "02", end: "05 October", sessionName: "Race")
    static let mockStatusFinished: Event.Status = .finished(winner: Driver.mockArray.map { $0.id })
    static let mockStatusLive: Status = .live(timeInterval: .init(100), sessionName: "Race")
    
    static let mockDetailsArray: [ShortDetails] = [
        .init(
            status: Event.mockStatusUpcoming,
            round: 1,
            title: "Title here",
            country: "Country here"
        ),
        .init(
            status: Event.mockStatusUpcoming,
            round: 1,
            title: "Title here",
            country: "Country here"
        ),
        .init(
            status: Event.mockStatusUpcoming,
            round: 1,
            title: "Title here",
            country: "Country here"
        ),
        .init(
            status: Event.mockStatusUpcoming,
            round: 1,
            title: "Title here",
            country: "Country here"
        )
    ]
}
