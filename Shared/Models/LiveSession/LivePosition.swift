import Foundation
import OSLog

struct LivePosition: Decodable, Identifiable {
    
    typealias ID = String

    let id: ID
    let position: Int
    let time: String?
    let tyre: Tyre
    let tyrePitCount: Int
}

extension LivePosition {

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
                Logger.liveSessionService.warning("⚠️ Unexpected `\(Self.self)` tyre type: \(rawValue)")
                self = .undefined
            }
        }
    }
}

extension LivePosition {
    
    static func getLivePositions() -> Resource<[Self]> {

        guard let url = URL(string: "\(Global.url)/v1/live-event") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}
