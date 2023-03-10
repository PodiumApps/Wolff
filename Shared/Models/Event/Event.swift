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
        
        guard
            let firstSessionDate: Date = event.sessions.first?.date,
            let finalSessionDate: Date = event.sessions.last?.date
        else {
            fatalError("There should have an interval date for event id -> \(event.id)")
        }
        
        formatter.dateFormat = "dd"
        
        let firstDay = formatter.string(from: firstSessionDate)
        let lastDay = formatter.string(from: finalSessionDate)
        
        let todayDay = formatter.string(from: Date())
        
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: finalSessionDate).uppercased()
        let todayMonth = formatter.string(from: Date())
        
        formatter.dateFormat = "HH"
        let actualHour = Int(formatter.string(from: Date())) ?? 0
        
        formatter.dateFormat = "mm"
        let actualMinutes = Int(formatter.string(from: Date())) ?? 0
        
        if event.id == nextEvent.id,
           event.sessions.filter({ $0.winnerID != nil }).count != event.sessions.count {
            
            if let nextDateEvent = event.sessions.first(where: { $0.winnerID == nil })?.date {
                
                formatter.dateFormat = "dd"
                let nextDayEvent = formatter.string(from: nextDateEvent)
                
                formatter.dateFormat = "MMMM"
                let nextMonthEvent = formatter.string(from: nextDateEvent)
                
                formatter.dateFormat = "HH"
                let nextHour = Int(formatter.string(from: nextDateEvent)) ?? 0
                
                formatter.dateFormat = "mm"
                let nextMinutes = Int(formatter.string(from: nextDateEvent)) ?? 0
                
                if todayDay == nextDayEvent,
                   todayMonth == nextMonthEvent {
                    guard
                        let sessionName = event.sessions.first(where: { $0.winnerID == nil })?.name
                    else {
                        fatalError("We should have a session name for \(event)")
                    }
                    
                    if actualHour >= nextHour, actualMinutes >= nextMinutes {
                        
                        return .live(title: sessionName.label, details: "")
                    } else {
                        return .current(
                            title: "\(nextHour - actualHour)h\(nextMinutes - actualMinutes)min to",
                            details: sessionName.label)
                    }
                }
            }
            
            guard
                let sessionName = event.sessions.first(where: { $0.winnerID == nil })?.name
            else {
                fatalError("We should have a session name for \(event)")
            }
            
            return .current(title: "\(firstDay) \(month)", details: sessionName.label)
        }
        
        if event.sessions.filter({ $0.winnerID != nil }).count == event.sessions.count  {
            
            let winnerID = event.sessions.first(where: { $0.name == .race })?.winnerID ?? ""
            
            let driverTicker = drivers.first(where: { $0.id == winnerID })?.driverTicker
            
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
