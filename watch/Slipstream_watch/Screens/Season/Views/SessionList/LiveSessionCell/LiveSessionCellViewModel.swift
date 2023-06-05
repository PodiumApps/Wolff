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

    private let navigation: SeasonNavigation
    private let sessionStandingsListViewModel: SessionStandingsListViewModel
    private var subscriptions = Set<AnyCancellable>()

    var sessionName: String
    var sessionID: Session.ID
    var podium: [String]
    var state: LiveSessionCellViewModel.State
    var action = PassthroughSubject<Action, Never>()

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

        self.setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .tapSession:
                    navigation.action.send(.goTo(route: .sessionStandingsList(sessionStandingsListViewModel)))
                }
            }
            .store(in: &subscriptions)
    }
}

extension LiveSessionCellViewModel {

    enum Action {

        case tapSession
    }

    enum State {
        case aboutToStart
        case happeningNow(podium: [String])
        case betweenOneMinuteAndFourHoursToGo(date: Date)
    }
}
