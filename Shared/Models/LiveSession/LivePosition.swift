import Foundation
import OSLog

struct LivePosition: Decodable, Identifiable {

    let id: Identifier<Driver>
    let position: Int
    let time: String?
    let tyre: SessionResult.Tyre
    let tyrePitCount: Int
}

extension LivePosition {
    
    static func getLivePositions() -> Resource<[Self]> {

        guard let url = URL(string: "\(Global.url)/v1/live-event") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}
