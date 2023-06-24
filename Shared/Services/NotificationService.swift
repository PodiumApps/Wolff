import Foundation
import OSLog
import Combine

protocol NotificationServiceRepresentable {

    var statePublisher: Published<NotificationService.State>.Publisher { get }
    var action: PassthroughSubject<NotificationService.Action, Never> { get }
}

class NotificationService: NotificationServiceRepresentable {

    struct Notification: Codable {

        let category: NotificationCategory
        var isOn: Bool
    }

    var statePublisher: Published<State>.Publisher { $state }
    @Published var state: State = .refreshing

    var action = PassthroughSubject<Action, Never>()
    var subscribers = Set<AnyCancellable>()

    @UserDefaultsWrapper(key: .notifications)
    private var notifications: [Notification]?

    init() {
        
        setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }

                switch action {
                case .fetchAll:
                    state = .refreshed(getNotifications())
                }
            }
            .store(in: &subscribers)
    }

    private func getNotifications() -> [Notification] {

        guard let persistedNotifications = notifications else {

            let updatedNotifications: [Notification] = [
                .init(category: .latestNews, isOn: false),
                .init(category: .sessionStart, isOn: false),
                .init(category: .sessionEnd, isOn: false)
            ]

            notifications = updatedNotifications

            if updatedNotifications.count == NotificationCategory.allCases.count {

                return updatedNotifications
            } else {

                Logger.notificationsService.info("Number of cells does not match number of notification categories.")
                state = .error

                return []
            }
        }

        return persistedNotifications
    }
}

extension NotificationService {

    enum Action {

        case fetchAll
    }

    enum State {

        case refreshing
        case refreshed([Notification])
        case error
    }

    enum NotificationCategory: String, Codable, CaseIterable {

        case latestNews = "latest-news"
        case sessionStart = "session-start"
        case sessionEnd = "session-end"
    }
}

extension NotificationService {

    static func make() -> NotificationService {

        .init()
    }
}
