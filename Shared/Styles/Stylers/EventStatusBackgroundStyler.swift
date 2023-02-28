import SwiftUI

protocol EventStatusBackgroundStylerRepresentable {

    var status: EventStatusBackgroundStyler.Status { get }
}

class EventStatusBackgroundStyler: EventStatusBackgroundStylerRepresentable {

    var status: Status

    var color: Color {
        switch status {
        case .current: return .Event.current
        case .liveSession: return .Event.liveSession
        case .completeOrUpcomingEvent: return .Event.completedOrUpcomingEvent
        }
    }

    init(status: Status) {
        self.status = status
    }
}

extension EventStatusBackgroundStyler {

    enum Status {
        case current
        case liveSession
        case completeOrUpcomingEvent
    }

    convenience init(grandPrixCardStatus: GrandPrixCardViewModel.Status) {

        let status: Status

        switch grandPrixCardStatus {
        case .current:
            status = .current
        case .live:
            status = .liveSession
        case .finished, .upcoming:
            status = .completeOrUpcomingEvent
        }

        self.init(status: status)
    }
}
