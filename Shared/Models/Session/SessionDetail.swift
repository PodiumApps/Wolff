import Foundation

struct SessionDetail: Decodable, Identifiable {
    
    typealias ID = Identifier<SessionDetail>
    
    let id: ID
    let driverId: Driver.ID
    let position: Int
    let laps: Int
    let tyrePitCount: Int
    let time: [String]
}

extension SessionDetail {
    
    struct Tyre: Decodable, Identifiable {
        
        let id: String
        let driverId: Driver.ID
        let tyre: SessionResult.Tyre
        let lap: Int
    }
    
    struct Position: Decodable, Identifiable {
        
        let id: String
        let driverId: Driver.ID
        let position: Int
        let lap: Int
    }
}

extension SessionDetail {
    
    enum Detail {
        
        case tyre(Driver.ID)
        case position(Driver.ID)
        
        var id: String {
            switch self {
            case .tyre: return "tyre"
            case .position: return "position"
            }
        }
        
        var driverID: String {
            switch self {
            case .tyre(let driverID), .position(let driverID):
                return driverID.string
            }
        }
    }
    
    static func getSession<T: Decodable>(for: T.Type = T.self, id: String, detail: Detail? = nil) -> Resource<[T]> {

        guard let url = URL(string: "\(Global.url)/v1/session/\(id)") else { fatalError("URL not found.") }
        print(url)
        
        let method: HttpMethod
        
        if let detail {
            let queryItems: [URLQueryItem] = [
                .init(name: "driver", value: detail.driverID),
                .init(name: "detail", value: detail.id)
            ]
            method = .get(queryItems, accessToken: Date().tokenString)
        } else {
            method = .get(accessToken: Date().tokenString)
        }

        return Resource(url: url, method: method)
    }
}
