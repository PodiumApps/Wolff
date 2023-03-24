import Foundation

protocol LiveEventCardViewModelRepresentable {

    var id: Event.ID { get }
    var title: String { get }
    var country: String { get }
    var round: Int { get }
    var timeInterval: TimeInterval { get }
    var sessionName: String { get }
}

final class LiveEventCardViewModel: LiveEventCardViewModelRepresentable {

    var id: Event.ID
    var title: String
    var country: String
    var round: Int
    var timeInterval: TimeInterval
    var sessionName: String

    init(
        id: Event.ID,
        title: String,
        country: String,
        round: Int,
        timeInterval: TimeInterval,
        sessionName: String
    ) {

        self.id = id
        self.title = title
        self.country = country
        self.round = round
        self.timeInterval = timeInterval
        self.sessionName = sessionName
    }
}
