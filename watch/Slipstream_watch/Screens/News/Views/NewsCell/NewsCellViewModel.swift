import Foundation
import Combine

protocol NewsCellViewModelRepresentable {

    var news: News { get }
    var enumeration: String { get }
    var action: PassthroughSubject<NewsDetailsViewModel.Action, Never> { get }
}

final class NewsCellViewModel: NewsCellViewModelRepresentable {

    var news: News
    var enumeration: String

    var action = PassthroughSubject<NewsDetailsViewModel.Action, Never>()
    var subscriptions = Set<AnyCancellable>()

    init(news: News, enumeration: String) {

        self.news = news
        self.enumeration = enumeration
    }
}

extension NewsCellViewModel {

    enum Action {

        case openDetails
    }
}
