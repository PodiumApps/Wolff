import Foundation

struct Session: Decodable, Identifiable, Hashable {
    
    let id: String
    let laps: Int
    let date: Date
    let name: Name
    let winnerID: String?
}

extension Session {
    
    enum Name: String, Decodable, Hashable {
        
        case firstPractice = "Practice 1"
        case secondPractice = "Practice 2"
        case thirdPractice = "Practice 3"
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
}
