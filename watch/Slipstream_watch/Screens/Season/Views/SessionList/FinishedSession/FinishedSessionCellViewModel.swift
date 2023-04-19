import Foundation

protocol FinishedSessionCellViewModelRepresentable {

    var session: String { get }
    var winners: [String] { get }
}

final class FinishedSessionCellViewModel: FinishedSessionCellViewModelRepresentable {

    var session: String
    var winners: [String]

    init(session: String, winners: [String]) {

        self.session = session
        self.winners = winners
    }
}
