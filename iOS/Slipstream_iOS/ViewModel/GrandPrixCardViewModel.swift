import Foundation

protocol GrandPrixCardRepresentable {

    var round: Int { get }
    var title: String { get }

    var grandPrixDate: String? { get }
    var circuitID: String? { get }

    var eventStatus: GrandPrixCardViewModel.EventStatus { get }

    var currentSessionTitle: String? { get }
    var currentSessionDetails: String? { get }

    var drivers: [DriverResult]? { get }
}

final class GrandPrixCardViewModel: GrandPrixCardRepresentable {

    var round: Int
    var title: String

    var grandPrixDate: String?
    var circuitID: String?

    var eventStatus: EventStatus

    var currentSessionTitle: String?
    var currentSessionDetails: String?

    var drivers: [DriverResult]?

    enum EventStatus {
        case upcoming
        case current
        case live
        case finished
    }

    init(
        round: Int,
        title: String,
        grandPrixDate: String? = .none,
        circuitID: String,
        eventSatus: EventStatus,
        currentSessionTitle: String? = .none,
        currentSessionDetails: String? = .none,
        drivers: [DriverResult]? = .none
    ) {

        self.round = round
        self.title = title
        self.grandPrixDate = grandPrixDate
        self.circuitID = circuitID
        self.eventStatus = eventSatus
        self.currentSessionTitle = currentSessionTitle
        self.currentSessionDetails = currentSessionDetails
        self.drivers = drivers
    }
}
