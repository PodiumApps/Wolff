import Foundation
import Combine

protocol NewsListViewModelRepresentable: ObservableObject {

    var action: PassthroughSubject<NewsListViewModel.Action, Never> { get }
    var state: NewsListViewModel.State { get }
}

final class NewsListViewModel: NewsListViewModelRepresentable {

    @Published var state: NewsListViewModel.State

    private var navigation: AppNavigationRepresentable
    private var subscriptions = Set<AnyCancellable>()
    private let newsService: NewsServiceRepresentable

    var action = PassthroughSubject<Action, Never>()
    private var subscribers = Set<AnyCancellable>()

    init(navigation: AppNavigationRepresentable, newsService: NewsServiceRepresentable) {

        self.navigation = navigation

        self.state = .loading
        self.newsService = newsService

        self.setUpServices()
        self.setUpBindings()
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

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }

                switch action {
                case .reloadService:
                    newsService.action.send(.fetchAll)
                }

            }
            .store(in: &subscribers)
    }

    private func buildNewsCells(news: [News]) -> NewsListViewModel.State {

        let cells: [NewsCellViewModel] = news.enumerated().compactMap { [weak self] index, article -> NewsCellViewModel? in
            
            guard let self else { return nil }
            
            let viewModel = NewsCellViewModel(news: article, enumeration: "\(index + 1) of \(news.count)")
            
            viewModel.action
                .receive(on: DispatchQueue.main)
                .sink { [weak self] action in

                    guard let self else { return }
                    switch action {
                    case .openDetails:
                        navigation.action.send(.append(route: .newsDetails(NewsDetailsViewModel(news: article))))
                    }
                }
                .store(in: &subscriptions)

            return viewModel
        }

        return .results(cells)
    }
}

extension NewsListViewModel {

    enum Action {

        case reloadService
    }

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
