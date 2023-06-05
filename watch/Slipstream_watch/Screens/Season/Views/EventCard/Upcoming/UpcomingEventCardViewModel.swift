import Foundation
import Combine

protocol UpcomingEventCardViewModelRepresentable: ObservableObject {

    var id: Event.ID { get }
    var title: String { get }
    var country: String { get }
    var round: Int { get }
    var start: String { get }
    var end: String { get }
    var sessionName: String { get }
    var timeInterval: TimeInterval? { get }
    var state: UpcomingEventCardViewModel.State { get }
    var action: PassthroughSubject<UpcomingEventCardViewModel.Action, Never> { get }
    var sessionListViewModel: SessionListViewModel { get }
}

final class UpcomingEventCardViewModel: UpcomingEventCardViewModelRepresentable {

    private let navigation: SeasonNavigation
    private var subscriptions = Set<AnyCancellable>()

    var id: Event.ID
    var title: String
    var country: String
    var round: Int
    var start: String
    var end: String
    var sessionName: String
    var timeInterval: TimeInterval?

    var state: State { setUpUpcomingEventsState() }
    var action = PassthroughSubject<Action, Never>()
    
    var sessionListViewModel: SessionListViewModel

    init(
        navigation: SeasonNavigation,
        id: Event.ID,
        title: String,
        country: String,
        round: Int,
        start: String,
        end: String,
        sessionName: String,
        timeInterval: TimeInterval? = nil,
        sessionListViewModel: SessionListViewModel
    ) {
        self.navigation = navigation

        self.id = id
        self.title = title
        self.country = country
        self.round = round
        self.start = start
        self.end = end
        self.sessionName = sessionName
        self.timeInterval = timeInterval
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

    private func setUpUpcomingEventsState() -> State {

        let eventDate = "\(start) - \(end)".capitalized

        guard let timeInterval else {
            return .moreThanFortyEightHours(eventDate: eventDate)
        }

        if timeInterval < 48 * .hourInterval {

            let timeToStart = timeInterval.hoursAndMinutes
            return .lessThanFortyEightHours(hours: timeToStart.hours, minutes: timeToStart.minutes)
        }

        return .moreThanFortyEightHours(eventDate: eventDate)
    }
}

extension UpcomingEventCardViewModel {

    enum Action {

        case tapEvent
    }

    enum State {

        case moreThanFortyEightHours(eventDate: String)
        case lessThanFortyEightHours(hours: Int, minutes: Int)
    }
}
