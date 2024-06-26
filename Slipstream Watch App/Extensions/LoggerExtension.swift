import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let driverAndConstructorService = Logger(subsystem: subsystem, category: "driverAndConstructorService")
    static let liveSessionService = Logger(subsystem: subsystem, category: "liveSessionService")
    static let eventService = Logger(subsystem: subsystem, category: "eventService")
    static let userService = Logger(subsystem: subsystem, category: "userService")
    static let newsService = Logger(subsystem: subsystem, category: "newsService")
    static let notificationsService = Logger(subsystem: subsystem, category: "notificationService")
}
