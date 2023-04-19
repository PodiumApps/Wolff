import Foundation

protocol LiveSessionCellViewModelRepresentable {

    var sessionName: String { get }
    var podium: [String] { get }
    var state: LiveSessionCellViewModel.State { get }
}

final class LiveSessionCellViewModel: LiveSessionCellViewModelRepresentable {

    var sessionName: String
    var podium: [String]
    var state: LiveSessionCellViewModel.State

    init(sessionName: String, podium: [String], state: LiveSessionCellViewModel.State) {

        self.sessionName = sessionName
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
