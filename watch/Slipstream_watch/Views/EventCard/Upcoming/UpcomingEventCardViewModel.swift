import Foundation

protocol UpcomingEventCardViewModelRepresentable {

    var id: Event.ID { get }
    var title: String { get }
    var country: String { get }
    var round: Int { get }
    var start: String { get }
    var end: String { get }
    var sessionName: String { get }
    var timeInterval: TimeInterval? { get }
}

final class UpcomingEventCardViewModel: UpcomingEventCardViewModelRepresentable {

    var id: Event.ID
    var title: String
    var country: String
    var round: Int
    var start: String
    var end: String
    var sessionName: String
    var timeInterval: TimeInterval?

    init(
        id: Event.ID,
        title: String,
        country: String,
        round: Int,
        start: String,
        end: String,
        sessionName: String,
        timeInterval: TimeInterval? = nil
    ) {

        self.id = id
        self.title = title
        self.country = country
        self.round = round
        self.start = start
        self.end = end
        self.sessionName = sessionName
        self.timeInterval = timeInterval
    }
}
