import Foundation
import Combine

protocol FinishedEventCardViewModelRepresentable: ObservableObject {

    var id: Event.ID { get }
    var title: String { get }
    var country: String { get }
    var round: Int { get }
    var podium: [String] { get }
    var sessionListViewModel: SessionListViewModel { get }
    var action: PassthroughSubject<FinishedEventCardViewModel.Action, Never> { get }
}

final class FinishedEventCardViewModel: FinishedEventCardViewModelRepresentable {

    private let navigation: AppNavigationRepresentable
    private var subscribers = Set<AnyCancellable>()

    var id: Event.ID
    var title: String
    var country: String
    var round: Int
    var podium: [String]
    var sessionListViewModel: SessionListViewModel

    var action = PassthroughSubject<Action, Never>()

    init(
        navigation: AppNavigationRepresentable,
        id: Event.ID,
        title: String,
        country: String,
        round: Int,
        podium: [String],
        sessionListViewModel: SessionListViewModel
    ) {

        self.navigation = navigation
        
        self.id = id
        self.title = title
        self.country = country
        self.round = round
        self.podium = podium
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
                    navigation.action.send(.append(route: .sessionsList(sessionListViewModel)))
                }
            }
            .store(in: &subscribers)
    }
}

extension FinishedEventCardViewModel {

    enum Action {

        case tapEvent
    }
}
