import Foundation

struct Event: Decodable {
    
    typealias ID = String
    
    let id: ID
    let firstGrandPrix: Int
    let lapRecord: String
    let name: String
    let title: String?
    let length: Double
    let raceDistance: Double
    let round: Int
    let sessions: [Session]
}

extension Event {

    enum Status {
        
        case upcoming(start: String, end: String, session: Session.Name?)
        case live(timeToEvent: String, session: Session.Name, drivers: [DriverResult])
        case finished(winner: String)
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
        
        formatter.dateFormat = "MMM"
        let firstMonth = formatter.string(from: firstSessionDate).uppercased()
        let lastMonth = formatter.string(from: finalSessionDate).uppercased()
        
        formatter.dateFormat = "dd"
        
        let firstDay = formatter.string(from: firstSessionDate) + (firstMonth == lastMonth ? "" : firstMonth)
        let lastDay = formatter.string(from: finalSessionDate) + lastMonth
        
        if event.id == nextEvent.id,
           event.sessions.filter({ $0.winnerID != nil }).count != event.sessions.count {
            
            if let nextSession = event.sessions.lazy.first(where: { $0.winnerID == nil }) {
                
                let intervaltimeStamp = nextSession.date.timeIntervalSinceNow
                let dayInSeconds: Double = 8*60*60
                
                if intervaltimeStamp < dayInSeconds {
                    
                    if intervaltimeStamp <= 0 && !liveDrivers.isEmpty {
                        let driverResult: [DriverResult] = liveDrivers.enumerated().map { index, driver in
                                .init(
                                    driverTicker: driver.driverTicker,
                                    value: index == 0 ? .first : index == 1 ? .second : .third
                                )
                        }
                        return .live(timeToEvent: "", session: nextSession.name, drivers: driverResult)
                    } else {
                        let finalString: String
                        if intervaltimeStamp  < 60 {
                            finalString = "About to start \(nextSession.name.label)"
                        } else {
                            let formatter = DateComponentsFormatter()
                            formatter.allowedUnits = [.hour, .minute]
                            
                            guard
                                let timeToEvent = formatter.string(from: intervaltimeStamp)
                            else {
                                fatalError("We should have a time to Event conversion")
                            }
                            
                            finalString = "\(timeToEvent.replacingOccurrences(of: ":", with: "h"))min to \(nextSession.name.label)"
                        }
                        
                        return .live(timeToEvent: finalString, session: nextSession.name, drivers: [])
                    }
                }
            }
            
            guard
                let sessionName = event.sessions.lazy.first(where: { $0.winnerID == nil })?.name
            else {
                fatalError("We should have a session name for \(event)")
            }
            
            return .upcoming(start: firstDay, end: lastDay, session: sessionName)
        }
        
        if
            event.sessions.lazy.filter({ $0.winnerID != nil }).count == event.sessions.count,
            let winnerID = event.sessions.lazy.first(where: { $0.name == .race })?.winnerID,
            let driverTicker = drivers.lazy.first(where: { $0.id == winnerID })?.driverTicker
        {
            
            return .finished(winner: driverTicker)
        }
        
        return .upcoming(start: firstDay, end: lastDay, session: nil)
    }
}
