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
    }
}
