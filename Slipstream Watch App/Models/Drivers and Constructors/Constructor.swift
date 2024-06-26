import Foundation

struct Constructor: Codable, Hashable, Identifiable {
    
    typealias ID = Identifier<Constructor>

    let id: ID
    let name: String
    let fullName: String
    let teamPrinciple: String
    let position: Int
    let points: Int
}

extension Constructor {

    static func getConstructors() -> Resource<[Self]> {

        guard let url = URL(string: "\(Global.url)/v1/constructors") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
    
    static func getConstructor(id: Int) -> Resource<Self> {

        guard let url = URL(string: "\(Global.url)/v1/constructor/\(id)") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}
