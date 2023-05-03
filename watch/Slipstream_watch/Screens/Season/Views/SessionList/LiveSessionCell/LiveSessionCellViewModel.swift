import Foundation

protocol LiveSessionCellViewModelRepresentable {

    var sessionName: String { get }
    var sessionID: Session.ID { get }
    var podium: [String] { get }
    var state: LiveSessionCellViewModel.State { get }

    func tapSession() -> Void
}

final class LiveSessionCellViewModel: LiveSessionCellViewModelRepresentable {

    private let navigation: SeasonNavigation
    private let sessionStandingsListViewModel: SessionStandingsListViewModel

    var sessionName: String
    var sessionID: Session.ID
    var podium: [String]
    var state: LiveSessionCellViewModel.State

    init(
        navigation: SeasonNavigation,
        sessionName: String,
        sessionID: Session.ID,
        podium: [String],
        state: LiveSessionCellViewModel.State,
        sessionStandingsListViewModel: SessionStandingsListViewModel
    ) {

        self.navigation = navigation
        self.sessionName = sessionName
        self.sessionID = sessionID
        self.podium = podium
        self.state = state
        self.sessionStandingsListViewModel = sessionStandingsListViewModel
    }

    func tapSession() {

        navigation.action.send(.goTo(route: .sessionStandingsList(sessionStandingsListViewModel)))
    }
}

extension LiveSessionCellViewModel {

    enum State {
        case aboutToStart
        case happeningNow(podium: [String])
        case betweenOneMinuteAndFourHoursToGo(date: Date)
    }
}
