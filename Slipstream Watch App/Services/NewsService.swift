import Foundation
import Combine
import OSLog

protocol NewsServiceRepresentable {

    var statePublisher: Published<NewsService.State>.Publisher { get }
    var action: PassthroughSubject<NewsService.Action, Never> { get }
}

final class NewsService: NewsServiceRepresentable {

    @Published private var state: State = .refreshing
    var statePublisher: Published<NewsService.State>.Publisher { $state }

    var action = PassthroughSubject<Action, Never>()

    private let networkManager: NetworkManagerRepresentable
    private var subscriptions = Set<AnyCancellable>()

    init(networkManager: NetworkManagerRepresentable) {

        self.networkManager = networkManager
        self.setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }
                Task {
                    switch action {
                    case .fetchAll:
                        self.state = .refreshing
                        await self.fetchAll()
                    case .updateAll:
                        await self.fetchAll()
                    }
                }
            }
            .store(in: &subscriptions)
    }

    private func fetchAll() async {

        do {
            let news = try await self.networkManager.load(News.getNews())
            Logger.newsService.info("Fetched \(news.count) news")

            state = .refreshed(news)
        } catch {

            Logger.newsService.error("Error \(error)")
            state = .error(error)
        }
    }
}

extension NewsService {

    enum Action {

        case fetchAll
        case updateAll
    }

    enum State {

        case refreshing
        case refreshed([News])
        case error(Error)
    }
}

extension NewsService {

    static func make() -> NewsService {

        .init(networkManager: NetworkManager.shared)
    }
}
