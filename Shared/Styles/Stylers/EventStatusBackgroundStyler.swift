import SwiftUI

protocol EventStatusBackgroundStylerRepresentable {

    var eventStatus: GrandPrixCardViewModel.EventStatus { get }
}

class EventStatusBackgroundStyler: EventStatusBackgroundStylerRepresentable {

    var eventStatus: GrandPrixCardViewModel.EventStatus

    var color: Color {
        switch eventStatus {
        case .current: return .current
        case .live: return .liveSession
        case .finished, .upcoming: return .completedOrUpcomingEvent
        }
    }

    init(eventStatus: GrandPrixCardViewModel.EventStatus) {
        self.eventStatus = eventStatus
    }
}
