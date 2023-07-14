import Foundation

struct DriverDetails: Decodable {

    let placeOfBirth: String
    let podiums: Int
    let allTimePoints: Int
    let grandPrix: Int
    let championships: Int
    let highestRacePos: Int
    let timesHighestRacePos: Int
    let highestGridPos: Int
}

extension DriverDetails {

    static func getDetails(for driverID: Driver.ID) -> Resource<Self> {

        guard let url = URL(string: "\(Global.url)/v1/driver-details/\(driverID.string)") else {
            fatalError("URL not found.")
        }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}


