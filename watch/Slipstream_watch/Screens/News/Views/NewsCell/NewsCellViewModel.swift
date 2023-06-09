import Foundation
import Combine

protocol NewsCellViewModelRepresentable {

    var news: News { get }
    var navigation: NewsNavigation { get }
    var action: PassthroughSubject<NewsDetailsViewModel.Action, Never> { get }
}

final class NewsCellViewModel: NewsCellViewModelRepresentable {

    var news: News
    var navigation: NewsNavigation

    var action = PassthroughSubject<NewsDetailsViewModel.Action, Never>()
    var subscriptions = Set<AnyCancellable>()

    init(news: News, navigation: NewsNavigation) {

        self.news = news
        self.navigation = navigation

        self.setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }
                switch action {
                case .openDetails:
                    navigation.action.send(.goTo(route: .newsDetails(NewsDetailsViewModel(news: news))))
                }
            }
            .store(in: &subscriptions)
    }
}

extension NewsCellViewModel {

    enum Action {

        case openDetails
    }
}
