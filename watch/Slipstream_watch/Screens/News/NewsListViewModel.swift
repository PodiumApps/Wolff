import Foundation
import Combine

protocol NewsListViewModelRepresentable: ObservableObject {

    var state: NewsListViewModel.State { get }
    var route: [NewsNavigation.Route] { get set }
}

final class NewsListViewModel: NewsListViewModelRepresentable {

    @Published var state: NewsListViewModel.State
    @Published var route: [NewsNavigation.Route]

    private var news: [News]

    private var navigation: NewsNavigation
    private var subscriptions = Set<AnyCancellable>()
    private let newsService: NewsServiceRepresentable

    init(navigation: NewsNavigation, newsService: NewsServiceRepresentable) {

        self.navigation = navigation
        self.route = []

        self.state = .loading
        self.newsService = newsService
        self.news = []

        self.setUpNavigation()
    }

    private func setUpNavigation() {

        navigation.routePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] navigation in

                guard let self else { return }

                guard let navigation else {

                    self.route = []
                    return
                }

                self.route.append(navigation)
            }
            .store(in: &subscriptions)

    }

    private func setUpServices() {

        newsService.action.send(.fetchAll)

        newsService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] newsService -> NewsListViewModel.State? in

                guard let self else { return nil }

                switch newsService {
                case .error(let error):
                    return .error(error.localizedDescription)
                case .refreshing:
                    return .loading
                case .refreshed(let news):

                    self.news = news

                    return self.buildNewsCells()
                }


            }
            .assign(to: &$state)
    }

    private func buildNewsCells() -> NewsListViewModel.State {

        let cells: [NewsCellViewModel] = news.compactMap { news in

            return NewsCellViewModel(news: news)
        }

        return .results(cells)
    }
}

extension NewsListViewModel {

    enum State: Equatable {

        case error(String)
        case results([NewsCellViewModel])
        case loading

        enum Identifier: String {

            case error
            case loading
            case results
        }

        var id: Identifier {
            switch self {
            case .loading: return .loading
            case .results: return .results
            case .error: return .error
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}
