import Foundation

protocol ScheduleCorouselViewModelRepresentable {

    var round: Int { get }
    var title: String { get }
    var grandPrixDate: String { get }
    var eventStatus: Event.Status { get }
}

final class ScheduleCarouselViewModel: ScheduleCorouselViewModelRepresentable {

    var round: Int
    var title: String
    var grandPrixDate: String
    var eventStatus: Event.Status

    init(round: Int, title: String, grandPrixDate: String, eventStatus: Event.Status) {

        self.round = round
        self.title = title.uppercased()
        self.grandPrixDate = grandPrixDate
        self.eventStatus = eventStatus
    }
}
