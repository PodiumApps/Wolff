import Foundation
import Combine

protocol LiveEventCardViewModelRepresentable: ObservableObject {

    var id: Event.ID { get }
    var title: String { get }
    var country: String { get }
    var round: Int { get }
    var timeInterval: TimeInterval { get }
    var sessionName: String { get }
    var podium: [String]? { get }
    var state: LiveEventCardViewModel.State { get }
    var sessionListViewModel: SessionListViewModel { get }
    var action: PassthroughSubject<LiveEventCardViewModel.Action, Never> { get }
}

final class LiveEventCardViewModel: LiveEventCardViewModelRepresentable {

    private let navigation: SeasonNavigation
    private var subscriptions = Set<AnyCancellable>()

    var id: Event.ID
    var title: String
    var country: String
    var round: Int
    var timeInterval: TimeInterval
    var sessionName: String
    var podium: [String]?

    var state: State
    var action = PassthroughSubject<Action, Never>()

    var sessionListViewModel: SessionListViewModel

    init(
        navigation: SeasonNavigation,
        id: Event.ID,
        title: String,
        country: String,
        round: Int,
        timeInterval: TimeInterval,
        sessionName: String,
        podium: [String]? = nil,
        state: State,
        sessionListViewModel: SessionListViewModel
    ) {

        self.navigation = navigation

        self.id = id
        self.title = title
        self.country = country
        self.round = round
        self.timeInterval = timeInterval
        self.sessionName = sessionName
        self.podium = podium
        self.state = state
        self.sessionListViewModel = sessionListViewModel

        self.setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .tapEvent:
                    navigation.action.send(.goTo(route: .sessionsList(sessionListViewModel)))
                }
            }
            .store(in: &subscriptions)
    }
}

extension LiveEventCardViewModel {

    enum Action {

        case tapEvent
    }

    enum State: Equatable {

        case betweenOneMinuteAndFourHoursToGo(hours: Int, minutes: Int)
        case aboutToStart // Less than one minute
        case happeningNow(podium: [String])
    }
}
