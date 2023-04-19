import Foundation

protocol UpcomingSessionCellViewModelRepresentable {

    var sessionName: String { get }
    var date: Date { get }
}

final class UpcomingSessionCellViewModel: UpcomingSessionCellViewModelRepresentable {

    var sessionName: String
    var date: Date

    init(sessionName: String, date: Date) {

        self.sessionName = sessionName
        self.date = date
    }
}
