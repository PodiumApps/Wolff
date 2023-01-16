import Foundation

protocol ResultCardRepresentable {

    var sessionType: Session.Name { get }
    var fastestLap: String { get }
    var drivers: [ResultCardViewModel.Driver] { get }
}

final class ResultCardViewModel: ResultCardRepresentable {

    struct Driver: Identifiable {

        let id: String // Driver Ticker
        let position: Position
    }

    let sessionType: Session.Name
    let fastestLap: String
    let drivers: [Driver]

    enum Position: Comparable {

        case first
        case second
        case third

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

    init(sessionType: Session.Name, fastestLap: String, drivers: [Driver]) {

        self.sessionType = sessionType
        self.fastestLap = fastestLap
        self.drivers = drivers.sorted(by: { $1.position.order < $0.position.order })
    }
}
