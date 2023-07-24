import Foundation
import Combine

protocol LiveSessionCellViewModelRepresentable {

    var sessionName: String { get }
    var sessionID: Session.ID { get }
    var podium: [String] { get }
    var state: LiveSessionCellViewModel.State { get }
    var action: PassthroughSubject<LiveSessionCellViewModel.Action, Never> { get }
}

final class LiveSessionCellViewModel: LiveSessionCellViewModelRepresentable {

    var sessionName: String
    var sessionID: Session.ID
    var podium: [String]
    var state: LiveSessionCellViewModel.State
    var action = PassthroughSubject<Action, Never>()

    init(
        sessionName: String,
        sessionID: Session.ID,
        podium: [String],
        state: LiveSessionCellViewModel.State
    ) {

        self.sessionName = sessionName
        self.sessionID = sessionID
        self.podium = podium
        self.state = state
    }
}

extension LiveSessionCellViewModel {

    enum Action {

        case tapSession
    }

    enum State {
        case aboutToStart
        case happeningNow(podium: [String], status: LiveSession.Status)
        case betweenOneMinuteAndFourHoursToGo(date: Date)
    }
}
