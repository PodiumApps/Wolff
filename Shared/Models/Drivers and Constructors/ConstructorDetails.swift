import Foundation

struct ConstructorDetails: Decodable {

    let base: String
    let firstTeamEntry: Int
    let worldChampionships: Int
    let technicalChief: String
    let powerUnit: String
    let chassis: String
    let polePositions: Int
    let fastestLaps: Int
}

extension ConstructorDetails {

    static func getDetails(for constructorID: Constructor.ID) -> Resource<Self> {

        guard let url = URL(string: "\(Global.url)/v1/constructor-details/\(constructorID.string)") else {
            fatalError("URL not found")
        }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}
