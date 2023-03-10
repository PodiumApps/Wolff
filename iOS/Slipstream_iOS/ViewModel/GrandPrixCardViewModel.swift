import Foundation

protocol GrandPrixCardViewModelRepresentable {

    var round: Int { get }
    var title: String { get }
    var eventStatus: Event.Status { get }
}

final class GrandPrixCardViewModel: GrandPrixCardViewModelRepresentable {

    var round: Int
    var title: String
    var eventStatus: Event.Status

    init(
        round: Int,
        title: String,
        eventStatus: Event.Status
    ) {

        self.round = round
        self.title = title.uppercased()
        self.eventStatus = eventStatus
    }
}
