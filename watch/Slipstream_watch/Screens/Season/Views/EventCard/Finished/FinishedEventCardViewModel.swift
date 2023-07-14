import Foundation
import Combine

protocol FinishedEventCardViewModelRepresentable: ObservableObject {

    var id: Event.ID { get }
    var title: String { get }
    var country: String { get }
    var round: Int { get }
    var podium: [String] { get }
    var action: PassthroughSubject<FinishedEventCardViewModel.Action, Never> { get }
}

final class FinishedEventCardViewModel: FinishedEventCardViewModelRepresentable {

    var id: Event.ID
    var title: String
    var country: String
    var round: Int
    var podium: [String]

    var action = PassthroughSubject<Action, Never>()

    init(
        id: Event.ID,
        title: String,
        country: String,
        round: Int,
        podium: [String]
    ) {
        
        self.id = id
        self.title = title
        self.country = country
        self.round = round
        self.podium = podium
    }
}

extension FinishedEventCardViewModel {

    enum Action {

        case tapEvent
    }
}
