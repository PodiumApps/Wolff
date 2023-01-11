import Foundation

struct Constructor: Decodable, Hashable, Identifiable {

    let id: String
    let name: String
    let teamPrinciple: String
    let standings: Details
}
