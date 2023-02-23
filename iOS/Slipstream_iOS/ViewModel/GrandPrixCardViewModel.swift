import Foundation

protocol GrandPrixCardRepresentable {

    var round: Int { get }
    var title: String { get }
    var grandPrixDate: String? { get }
    var eventStatus: GrandPrixCardViewModel.Status { get }

}

final class GrandPrixCardViewModel: GrandPrixCardRepresentable {

    var round: Int
    var title: String
    var grandPrixDate: String?
    var eventStatus: Status

    init(
        round: Int,
        title: String,
        grandPrixDate: String? = nil,
        eventSatus: Status
    ) {

        self.round = round
        self.title = title
        self.grandPrixDate = grandPrixDate
        self.eventStatus = eventSatus
    }
}

extension GrandPrixCardViewModel {

    enum Status {
        case upcoming(details: String)
        case current(title: String, details: String)
        case live(title: String, details: String)
        case finished(drivers: [DriverResult])
    }
}
