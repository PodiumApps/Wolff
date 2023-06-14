import Foundation
import Combine

protocol NewsListViewModelRepresentable: ObservableObject {

    var state: NewsListViewModel.State { get }
}

final class NewsListViewModel: NewsListViewModelRepresentable {

    @Published var state: NewsListViewModel.State

    private var navigation: AppNavigationRepresentable
    private var subscriptions = Set<AnyCancellable>()
    private let newsService: NewsServiceRepresentable

    init(navigation: AppNavigationRepresentable, newsService: NewsServiceRepresentable) {

        self.navigation = navigation

        self.state = .loading
        self.newsService = newsService
        self.setUpServices()
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

                    return self.buildNewsCells(news: news)
                }
            }
            .assign(to: &$state)
    }

    private func buildNewsCells(news: [News]) -> NewsListViewModel.State {

        let cells: [NewsCellViewModel] = news.enumerated().compactMap { [weak self] index, article in
            
            guard let self else { return nil }

            return .init(news: article, enumeration: "\(index + 1) of \(news.count)", navigation: navigation)
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

extension NewsListViewModel {

    static func make(navigation: AppNavigationRepresentable) -> NewsListViewModel {

        .init(navigation: navigation, newsService: ServiceLocator.shared.newsService)
    }
}
