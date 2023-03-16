import Foundation

struct Event: Decodable {
    
    typealias ID = String
    
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

    enum Status {
        
        case upcoming(start: String, end: String, sessionName: String, timeInterval: TimeInterval? = nil)
        case live(timeInterval: TimeInterval, sessionName: String, driverTickers: [String])
        case finished(winner: [Driver.ID])
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
    
    static func getEventStatus(
        for event: Self,
        comparing nextEvent: Self,
        drivers: [Driver],
        liveDrivers: [Driver] = []
    ) -> Status {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_us")
        
        guard
            let firstSessionDate: Date = event.sessions.first?.date,
            let finalSessionDate: Date = event.sessions.last?.date
        else {
            fatalError("There should have an interval date for event id -> \(event.id)")
        }
        
        formatter.dateFormat = "MMMM"
        let firstMonth = formatter.string(from: firstSessionDate).uppercased()
        let lastMonth = formatter.string(from: finalSessionDate).uppercased()
        
        formatter.dateFormat = "dd"
        
        let firstDay = formatter.string(from: firstSessionDate) + (firstMonth == lastMonth ? "" : " " + firstMonth)
        let lastDay = formatter.string(from: finalSessionDate) + " " + lastMonth
        
        if event.id == nextEvent.id,
           event.sessions.filter({ !$0.winners.isEmpty }).count != event.sessions.count {
            
            if let nextSession = event.sessions.lazy.first(where: { $0.winners.isEmpty }) {
                
                let intervaltimeStamp = nextSession.date.timeIntervalSinceNow
                let liveInSeconds: Double = 4*60*60
                
                if intervaltimeStamp < liveInSeconds {
                    
                    if intervaltimeStamp <= 0 && !liveDrivers.isEmpty {
                        let driverResult: [String] = liveDrivers.map(\.driverTicker)
                        return .live(
                            timeInterval: .init(0),
                            sessionName: nextSession.name.label,
                            driverTickers: driverResult
                        )
                    } else {
                        
                    
                        if intervaltimeStamp < 60 {
                            return .live(
                                timeInterval: .init(0),
                                sessionName: nextSession.name.label,
                                driverTickers: []
                            )
                        }
                        
                        return .live(
                            timeInterval: intervaltimeStamp,
                            sessionName: nextSession.name.label,
                            driverTickers: []
                        )
                    }
                }
            }
            
            if let session = event.sessions.lazy.first(where: { $0.winners.isEmpty }){
                return .upcoming(
                    start: firstDay,
                    end: lastDay,
                    sessionName: session.name.label,
                    timeInterval: session.date.timeIntervalSinceNow
                )
            }
        }
        
        if
            event.sessions.lazy.filter({ !$0.winners.isEmpty }).count == event.sessions.count,
            let winners = event.sessions.lazy.first(where: { $0.name == .race })?.winners
        {
            
            return .finished(winner: winners)
        }
        
        return .upcoming(
            start: firstDay,
            end: lastDay,
            sessionName: "",
            timeInterval: nil
        )
    }
}

extension Event {
    
    struct Details {
        
        let status: Status
        let round: Int
        let title: String
        let country: String
    }
    
    static let mockStatusUpcoming: Event.Status = .upcoming(start: "02", end: "05 October", sessionName: "Race")
    static let mockStatusFinished: Event.Status = .finished(winner: Driver.mockArray.map { $0.id })
    static let mockStatusLive: Status = .live(
        timeInterval: .init(100),
        sessionName: "Race",
        driverTickers: [
            Driver.mockHamilton.driverTicker,
            Driver.mockAlonso.driverTicker,
            Driver.mockVertasppen.driverTicker
        ]
    )
    
    static let mockDetailsArray: [Details] = [
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
