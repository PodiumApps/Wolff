import Foundation

protocol LiveSessionCellViewModelRepresentable {

    var sessionName: String { get }
    var sessionID: Session.ID { get }
    var podium: [String] { get }
    var state: LiveSessionCellViewModel.State { get }
}

final class LiveSessionCellViewModel: LiveSessionCellViewModelRepresentable {

    var sessionName: String
    var sessionID: Session.ID
    var podium: [String]
    var state: LiveSessionCellViewModel.State

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

    enum State {
        case aboutToStart
        case happeningNow(podium: [String])
        case betweenOneMinuteAndFourHoursToGo(date: Date)
    }
}
