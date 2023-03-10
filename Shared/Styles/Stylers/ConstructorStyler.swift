import SwiftUI

protocol ConstructorStylerRepresentable {

    var constructor: ConstructorStyler.Details { get }
}

class ConstructorStyler: ConstructorStylerRepresentable {

    let constructor: Details

    enum Details: String, CaseIterable {

        case alfa_romeo_ferrari
        case alphatauri_rbpt
        case alpine_renault
        case aston_martin_aramco_mercedes
        case ferrari
        case haas_ferrari
        case mclaren_mercedes
        case mercedes
        case red_bull_racing_rbpt
        case williams_mercedes
        case noTeam

        var color: Color {
            switch self {
            case .alfa_romeo_ferrari: return .Constructor.alphaRomeo
            case .alphatauri_rbpt: return .Constructor.alphaTauri
            case .alpine_renault: return .Constructor.alpine
            case .aston_martin_aramco_mercedes: return .Constructor.astonMartin
            case .ferrari: return .Constructor.ferrari
            case .haas_ferrari: return .Constructor.haas
            case .mclaren_mercedes: return .Constructor.mclaren
            case .mercedes: return .Constructor.mercedes
            case .red_bull_racing_rbpt: return .Constructor.redBull
            case .williams_mercedes: return .Constructor.williams
            case .noTeam: return .Constructor.noTeam
            }
        }
    }

    init(constructor: Constructor.ID) {
        self.constructor = Details.allCases.first(where: { $0.rawValue == constructor.string }) ?? .noTeam
    }

}
