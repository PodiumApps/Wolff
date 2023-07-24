import Foundation
import Combine

protocol NewsDetailsViewModelRepresentable {

    var news: News { get }
}

final class NewsDetailsViewModel: NewsDetailsViewModelRepresentable {

    var news: News

    init(news: News) {

        self.news = news
    }
}

extension NewsDetailsViewModel {

    enum Action {

        case openDetails
    }
}
