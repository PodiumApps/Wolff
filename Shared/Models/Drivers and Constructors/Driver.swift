import Foundation

struct Driver: Decodable, Identifiable, Hashable {

    let id: String
    let carNumber: Int
    let codeName: String
    let name: String
    let birth: Date
    let constructor: Constructor
    let standings: Details
}

//extension Driver {
//
//    static func getDrivers() -> Resource<[Self]> {
//
//        guard let url = URL(string: "https://slipstream.perguntashamuitas.com/drivers.php") else {
//            fatalError("URL not found.")
//        }
//
//        return Resource(url: url, method: .get())
//    }
//}
