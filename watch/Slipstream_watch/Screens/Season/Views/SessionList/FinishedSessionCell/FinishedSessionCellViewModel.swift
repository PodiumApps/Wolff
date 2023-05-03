import Foundation

protocol FinishedSessionCellViewModelRepresentable {

    var sessionID: Session.ID { get }
    var sessionName: String { get }
    var winners: [String] { get }

    func tapSession() -> Void
}

final class FinishedSessionCellViewModel: FinishedSessionCellViewModelRepresentable {

    private let navigation: SeasonNavigation
    private let sessionStandingsListViewModel: SessionStandingsListViewModel

    var sessionID: Session.ID
    var sessionName: String
    var winners: [String]

    init(
        navigation: SeasonNavigation,
        sessionID: Session.ID,
        session: String,
        winners: [String],
        sessionStandingsListViewModel: SessionStandingsListViewModel
    ) {

        self.navigation = navigation
        self.sessionStandingsListViewModel = sessionStandingsListViewModel

        self.sessionID = sessionID
        self.sessionName = session
        self.winners = winners
    }

    func tapSession() {

        navigation.action.send(.goTo(route: .sessionStandingsList(sessionStandingsListViewModel)))
    }
}
