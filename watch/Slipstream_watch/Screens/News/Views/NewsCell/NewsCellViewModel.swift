import Foundation

protocol NewsCellViewModelRepresentable {

    var news: News { get }
}

final class NewsCellViewModel: NewsCellViewModelRepresentable {

    var news: News

    init(news: News) {

        self.news = news
    }
}
