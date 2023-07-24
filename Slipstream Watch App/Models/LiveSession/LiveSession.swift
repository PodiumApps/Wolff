import Foundation
import OSLog

struct LiveSession: Decodable, Identifiable {

    typealias ID = Identifier<Session>

    let id: ID
    let standings: [Position]
    let status: Status

    struct Position: Decodable, Identifiable {

        typealias ID = Identifier<Position>
        
        let id: Identifier<Position>
        let driverId: Identifier<Driver>
        let position: Int
        let time: String?
        let tyre: SessionResult.Tyre
        let tyrePitCount: Int
    }

    struct Status: Decodable {

        let redFlag: Bool
        let state: String
    }
}

extension LiveSession {
    
    static func getLiveSession() -> Resource<Self> {

        guard let url = URL(string: "\(Global.url)/v1/live-event") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}
