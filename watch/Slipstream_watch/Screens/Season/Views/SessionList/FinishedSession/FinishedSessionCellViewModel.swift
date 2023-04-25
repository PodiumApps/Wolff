import Foundation

protocol FinishedSessionCellViewModelRepresentable {

    var sessionID: Session.ID { get }
    var sessionName: String { get }
    var winners: [String] { get }
}

final class FinishedSessionCellViewModel: FinishedSessionCellViewModelRepresentable {

    var sessionID: Session.ID
    var sessionName: String
    var winners: [String]

    init(sessionID: Session.ID, session: String, winners: [String]) {

        self.sessionID = sessionID
        self.sessionName = session
        self.winners = winners
    }
}
