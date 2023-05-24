import Foundation

struct DriverDetails: Decodable, Hashable {

    let placeOfBirth: String
    let podiums: Int
    let allTimePoints: Int
    let grandPrixEntered: Int
    let championships: Int
    let highestRacePosition: Int
    let timesHighestRacePosition: Int
    let highestGridPos: Int
}

extension DriverDetails {

    static func getDetails(for driverID: String) -> Resource<Self> {

        guard let url = URL(string: "\(Global.url)/v1/driver-details/\(driverID)") else {
            fatalError("URL not found.")
        }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}


