import SwiftUI

protocol EventStatusBackgroundStylerRepresentable {

    var status: EventStatusBackgroundStyler.Status { get }
}

class EventStatusBackgroundStyler: EventStatusBackgroundStylerRepresentable {

    var status: Status

    var color: Color {
        switch status {
        case .upcoming(let hasSession):
            return hasSession ? .Event.current : .Event.completedOrUpcomingEvent
        case .liveSession:
            return .Event.liveSession
        case .complete:
            return .Event.completedOrUpcomingEvent
        }
    }
    
    var titleFont: Font {
        
        switch status {
        case .liveSession:
            return .system(size: 16, weight: .semibold, design: .monospaced)
        case .upcoming(let hasSession):
            return .system(size: hasSession ? 16 : 24, weight: .semibold, design: .monospaced)
        case .complete:
            return .system(size: 24, weight: .semibold, design: .monospaced)
        }
    }

    init(status: Status) {
        
        self.status = status
    }
}

extension EventStatusBackgroundStyler {

    enum Status {
        
        case upcoming(hasSession: Bool)
        case liveSession
        case complete
    }

    convenience init(grandPrixCardStatus: Event.Status) {

        let status: Status

        switch grandPrixCardStatus {
        case .live:
            status = .liveSession
        case .upcoming(_, _, _, let session):
            status = .upcoming(hasSession: session != nil)
        case .finished, .calledOff:
            status = .complete
        }

        self.init(status: status)
    }
}
