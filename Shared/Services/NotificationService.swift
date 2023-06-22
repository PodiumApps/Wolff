import Foundation

enum NotificationCategory: String, Codable, CaseIterable {

    case latestNews = "latest-news"
    case sessionStart = "session-start"
    case sessionEnd = "session-end"
}

class NotificationService {

    struct Notification: Codable {

        let category: NotificationCategory
    }

    @UserDefaultsWrapper(key: .notifications)
    private var notifications: [Notification]?

    func getNotifications() -> [Notification]? {

        return notifications
    }

    func enableAll() {

        guard notifications == nil else { return }

        var createdNotifications = [Notification]()

        for category in NotificationCategory.allCases {

           createdNotifications += [
                .init(category: category),
                .init(category: category),
                .init(category: category)
            ]
        }

        self.notifications = createdNotifications
    }

    func disable(for category: NotificationCategory) {

        guard let notifications else { return }

        var updatedNotifications = [Notification]()

        for notification in notifications {

            if notification.category != category {

                updatedNotifications.append(notification)
            }
        }

        self.notifications = updatedNotifications
    }

    func enable(for category: NotificationCategory) {

        guard let notifications else { return }

        self.notifications?.append(.init(category: category))
    }
}

extension NotificationService {

    static func make() -> NotificationService {

        .init()
    }
}
