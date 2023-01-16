import Foundation

struct Session: Decodable, Identifiable, Hashable {
    
    let id: String
    let fastestDriver: Driver?
    let circuit: Circuit
    let round: Int
    let laps: Int
    let date: Date
    let name: Name
    let timeLeft: String?
}

extension Session {
    
    enum Name: String, Decodable, Hashable {
        
        case firstPractice = "First Practice"
        case secondPractice = "Second Practice"
        case thirdPractice = "Third Practice"
        case qualifying = "Qualifying"
        case sprint = "Sprint"
        case race = "Race"

        var label: String {

            switch self {
            case .firstPractice: return "Practice 1"
            case .secondPractice: return "Practice 2"
            case .thirdPractice: return "Practice 3"
            case .qualifying: return "Qualifying"
            case .sprint: return "Sprint Race"
            case .race: return "Race"
            }
        }
    }

    static let mockSession: Self = .init(
        id: "race",
        fastestDriver: Driver.mockHamilton,
        circuit: Circuit.mockCircuit,
        round: 4,
        laps: 52,
        date: Date(),
        name: .race,
        timeLeft: "1 hour"
    )
}
