import Foundation
import OSLog
import Combine
import WatchKit
import UserNotifications

protocol NotificationServiceRepresentable {

    var state: NotificationService.State { get }
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
                case .registerNotification:
                    registerForRemoteNotifications()
                case .checkPushNotificationsAuthorizationStatus:
                    checkPushNotificationStatus()
                case .fetchAll:
                    state = .refreshed(getNotifications(), showWarning: false)
                case .update(let notifications):
                    updateNotifications(notifications: notifications)
                    state = .refreshed(notifications, showWarning: false)
                }
            }
            .store(in: &subscribers)
    }

    private func registerForRemoteNotifications() {

        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]

        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { [weak self] authorised, error in

                guard let self, error == nil else { return }

                if authorised {

                    self.state = .refreshed(self.toggleAllNotifications(to: true), showWarning: false)
                } else {

                    self.state = .refreshed(self.toggleAllNotifications(), showWarning: false)
                }

                WKExtension.shared().registerForRemoteNotifications()
            }
        )
    }

    private func checkPushNotificationStatus() -> Void {

        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings { [weak self] settings in

            guard let self else { return }

            let status: UNAuthorizationStatus = settings.authorizationStatus

            switch status {
            case .notDetermined:
                self.registerForRemoteNotifications()
            case .denied:
                self.toggleAllNotifications()
                self.state = .refreshed(getNotifications(), showWarning: true)
            case .authorized, .provisional:
                return
            }
        }
    }

    private func getNotifications() -> [Notification] {

        guard let persistedNotifications = notifications else {

            return toggleAllNotifications()
        }

        return persistedNotifications
    }

    private func updateNotifications(notifications: [Notification]) {

        self.notifications = notifications

        // Post to server.
    }

    private func toggleAllNotifications(to newValue: Bool = false) -> [Notification] {

        let updatedNotifications: [Notification] = [
            .init(category: .latestNews, isOn: newValue),
            .init(category: .sessionStart, isOn: newValue),
            .init(category: .sessionEnd, isOn: newValue)
        ]

        notifications = updatedNotifications

        if updatedNotifications.count != NotificationCategory.allCases.count {

            Logger.notificationsService.info("Number of cells does not match number of notification categories.")
            state = .error

            return []
        }


        updateNotifications(notifications: updatedNotifications)

        return updatedNotifications
    }
}

extension NotificationService {

    enum Action {

        case fetchAll
        case registerNotification
        case checkPushNotificationsAuthorizationStatus
        case update([Notification])
    }

    enum State {

        case refreshing
        case refreshed([Notification], showWarning: Bool)
        case error
    }

    enum NotificationCategory: String, Codable, CaseIterable {

        case latestNews = "latest-news"
        case sessionStart = "session-start"
        case sessionEnd = "session-end"

        var label: String {
            switch self {
            case .latestNews: return "Latest News"
            case .sessionStart: return "Session Start"
            case .sessionEnd: return "Session End"
            }
        }
    }
}

extension NotificationService {

    static func make() -> NotificationService {

        .init()
    }
}
