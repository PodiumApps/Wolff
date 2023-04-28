import Foundation

struct Session: Decodable, Identifiable {
    
    typealias ID = Identifier<Session>
    
    let id: ID
    let laps: Int
    var date: Date
    let name: Name
    let winners: [Driver.ID]
}

extension Session {
    
    enum Name: String, Decodable, Hashable {
        
        case firstPractice = "Practice 1"
        case secondPractice = "Practice 2"
        case thirdPractice = "Practice 3"
        case qualifying = "Qualifying"
        case sprintShootout = "Sprint Shootout"
        case sprint = "Sprint"
        case sprintShootout = "Sprint Shootout"
        case race = "Race"

        var label: String {

            switch self {
            case .firstPractice: return "Practice 1"
            case .secondPractice: return "Practice 2"
            case .thirdPractice: return "Practice 3"
            case .qualifying: return "Qualifying"
            case .sprintShootout: return "Sprint Shootout"
            case .sprint: return "Sprint Race"
            case .sprintShootout: return "Sprint Shootout"
            case .race: return "Race"
            }
        }
    }
}
