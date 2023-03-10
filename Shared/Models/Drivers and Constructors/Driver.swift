import Foundation

struct Driver: Decodable, Identifiable, Hashable {
    
    typealias ID = String

    let id: ID
    let carNumber: Int
    let firstName: String
    let lastName: String
    let driverTicker: String
    let position: Int
    let points: Int
    let constructorId: String
    
    var fullName: String { firstName + " " + lastName }
}

extension Driver {

    static func getDrivers() -> Resource<[Self]> {

        guard let url = URL(string: "\(Global.url)/v1/drivers") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
    
    static func getDriver(id: String) -> Resource<Self> {

        guard let url = URL(string: "\(Global.url)/v1/driver/\(id)") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}
