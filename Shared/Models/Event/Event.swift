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
        case current(title: String, details: String, isToday: Bool)
        case live(title: String, details: String)
        case finished(drivers: [DriverResult])
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
        drivers: [Driver]
    ) -> Status {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_us")
        
        guard
            let firstSessionDate: Date = event.sessions.first?.date,
            let finalSessionDate: Date = event.sessions.last?.date
        else {
            fatalError("There should have an interval date for event id -> \(event.id)")
        }
        
        formatter.dateFormat = "dd"
        
        let firstDay = formatter.string(from: firstSessionDate)
        let lastDay = formatter.string(from: finalSessionDate)
        
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: finalSessionDate).uppercased()
        
        if event.id == nextEvent.id,
           event.sessions.filter({ $0.winnerID != nil }).count != event.sessions.count {
            
            if let nextSession = event.sessions.lazy.first(where: { $0.winnerID == nil }) {
                
                let intervaltimeStamp = nextSession.date.timeIntervalSinceNow
                let dayInSeconds: Double = 24*60*60
                
                if intervaltimeStamp < dayInSeconds {
                    
                    if intervaltimeStamp <= 0 {
                        return .live(title: nextSession.name.label, details: "")
                    } else {
                        let finalString: String
                        if intervaltimeStamp  < 60 {
                            finalString = "About to start"
                        } else {
                            let formatter = DateComponentsFormatter()
                            formatter.allowedUnits = [.hour, .minute]
                            
                            guard
                                let timeToEvent = formatter.string(from: intervaltimeStamp)
                            else {
                                fatalError("We should have a time to Event conversion")
                            }
                            
                            finalString = "\(timeToEvent.replacingOccurrences(of: ":", with: "h"))min to"
                        }
                        
                        return .current(
                            title: "\(finalString)",
                            details: nextSession.name.label,
                            isToday: true
                        )
                    }
                }
            }
            
            guard
                let sessionName = event.sessions.lazy.first(where: { $0.winnerID == nil })?.name
            else {
                fatalError("We should have a session name for \(event)")
            }
            
            return .current(title: "\(firstDay) \(month)", details: sessionName.label, isToday: false)
        }
        
        if event.sessions.lazy.filter({ $0.winnerID != nil }).count == event.sessions.count  {
            
            let winnerID = event.sessions.lazy.first(where: { $0.name == .race })?.winnerID ?? .init("")
            
            let driverTicker = drivers.lazy.first(where: { $0.id == winnerID })?.driverTicker
            
            return .finished(
                drivers: [
                    .init(
                        driverTicker: driverTicker ?? "",
                        value: .first
                    )
                ]
            )
        }
        
        return .upcoming(details: "\(firstDay) - \(lastDay) \(month)")
    }
}
