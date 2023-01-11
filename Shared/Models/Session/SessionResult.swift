import Foundation

struct SessionResult: Decodable, Identifiable, Hashable {
    
    let id: String
    let driver: Driver
    let points: Int?
    let tirePitCount: Int
    let startingGrid: Int
    let session: Session
    let tireName: TireName
    let position: Int
    var time: Double
    let lap: Int
}

extension SessionResult {
    
    enum TireName: String, Decodable, Hashable {
        
        case soft = "Soft"
        case medium = "Medium"
        case hard = "Hard"
        case wet = "Wet"
        case intermediate = "Intermediate"
    }
}
