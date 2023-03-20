import Foundation
import OSLog

struct SessionResult: Decodable, Identifiable {
    
    typealias ID = Identifier<SessionResult>
    
    let id: ID
    let driver: Driver
    let points: Int?
    let tirePitCount: Int
    let startingGrid: Int
    let session: Session
    let tireName: Tyre
    let position: Int
    var time: Double
    let lap: Int
}

extension SessionResult {
    
    enum Tyre: Decodable {
        case soft
        case medium
        case hard
        case intermediate
        case wet
        case undefined
        
        init(from decoder: Decoder) throws {
            
            let rawValue: String = try decoder.singleValueContainer().decode(String.self)
            
            switch rawValue.lowercased() {
            case "soft":
                self = .soft
            case "medium":
                self = .medium
            case "hard":
                self = .hard
            case "intermediate":
                self = .intermediate
            case "wet":
                self = .wet
            default:
                Logger.eventService.warning("⚠️ Unexpected `\(Self.self)` tyre type: \(rawValue)")
                self = .undefined
            }
        }
    }
}
