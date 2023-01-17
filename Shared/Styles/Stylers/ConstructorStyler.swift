import SwiftUI

protocol ConstructorStylerRepresentable {

    var constructor: ConstructorStyler.Constructor { get }
}

class ConstructorStyler: ConstructorStylerRepresentable {

    let constructor: Constructor

    enum Constructor: String, CaseIterable {

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
            case .alfa_romeo_ferrari: return .alphaRomeo
            case .alphatauri_rbpt: return .alphaTauri
            case .alpine_renault: return .alpine
            case .aston_martin_aramco_mercedes: return .astonMartin
            case .ferrari: return .ferrari
            case .haas_ferrari: return .haas
            case .mclaren_mercedes: return .mclaren
            case .mercedes: return .mercedes
            case .red_bull_racing_rbpt: return .redBull
            case .williams_mercedes: return .williams
            case .noTeam: return .primary
            }
        }
    }

    init(constructor: String) {
        self.constructor = Constructor.allCases.first(where: { $0.rawValue == constructor }) ?? .noTeam
    }

}
