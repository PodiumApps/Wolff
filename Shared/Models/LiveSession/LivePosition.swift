import Foundation

struct LivePosition: Decodable, Identifiable {

    let id: String
    let position: Int
    let time: String?
    let tyre: Tyre
    let tyrePitCount: Int
}

extension LivePosition {

    enum Tyre: String, Decodable {
        case soft = "soft"
        case medium = "medium"
        case hard = "hard"
        case intermediate = "intermediate"
        case wet = "wet"

        static func getTyreStyle(for tyre: Self) -> SessionDriverRowViewModel.Tyre {

            switch tyre {
            case .soft: return .soft
            case .medium: return .medium
            case .hard: return .hard
            case .intermediate: return .intermediate
            case .wet: return .wet
            }
        }
    }
}

extension LivePosition {
    
    static func getLivePositions() -> Resource<[Self]> {

        guard let url = URL(string: "\(Global.url)/v1/live-event") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}
