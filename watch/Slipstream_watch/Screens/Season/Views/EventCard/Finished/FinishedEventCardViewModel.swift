import Foundation

protocol FinishedEventCardViewModelRepresentable: ObservableObject {

    var route: [AppViewModel.Route] { get set }
    var id: Event.ID { get }
    var title: String { get }
    var country: String { get }
    var round: Int { get }
    var podium: [String] { get }
    var sessionListViewModel: SessionListViewModel { get }

    func tapEvent() -> Void
}

final class FinishedEventCardViewModel: FinishedEventCardViewModelRepresentable {

    var route: [AppViewModel.Route]

    var id: Event.ID
    var title: String
    var country: String
    var round: Int
    var podium: [String]
    var sessionListViewModel: SessionListViewModel

    init(
        route: [AppViewModel.Route],
        id: Event.ID,
        title: String,
        country: String,
        round: Int,
        podium: [String],
        sessionListViewModel: SessionListViewModel
    ) {

        self.route = route
        
        self.id = id
        self.title = title
        self.country = country
        self.round = round
        self.podium = podium
        self.sessionListViewModel = sessionListViewModel
    }

    func tapEvent() {
        
        route.append(.sessionsList(self.sessionListViewModel))
    }
}
