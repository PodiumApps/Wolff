import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let driverAndConstructorService = Logger(subsystem: subsystem, category: "driverAndConstructorService")
    static let liveSessionService = Logger(subsystem: subsystem, category: "liveSessionService")
}
