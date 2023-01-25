import Foundation

struct DriverResult: Identifiable {

    let id = UUID().uuidString
    let driverTicker: String // Driver Ticker
    let value: Value

    enum Value: Int {

        case first = 1
        case second = 2
        case third = 3

        var label: String {
            switch self {
            case .first: return "1"
            case .second: return "2"
            case .third: return "3"
            }
        }

        var order: Int {
            switch self {
            case .first: return 0
            case .second: return 1
            case .third: return 2
            }
        }

        var showTrophyImage: Bool { self == .first }
    }
}
