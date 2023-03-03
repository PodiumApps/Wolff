import SwiftUI

protocol SessionDriverStylerRepresentable {
    
    var tyre: SessionDriverStyler.Tyre { get }
    var constructorStyler: ConstructorStylerRepresentable { get }
}

class SessionDriverStyler: SessionDriverStylerRepresentable {
    
    let tyre: Tyre
    let constructorStyler: ConstructorStylerRepresentable
    
    init(tyre: Tyre, constructorId: String) {
        
        self.tyre = tyre
        
        self.constructorStyler = ConstructorStyler(constructor: constructorId)
    }
    
}

extension SessionDriverStyler {
    
    enum Tyre {
        case soft
        case medium
        case hard
        case intermediate
        case wet
        case undefined

        var color: Color {
            switch self {
            case .soft: return .Tyre.soft
            case .medium: return .Tyre.medium
            case .hard: return .Tyre.hard
            case .intermediate: return .Tyre.intermediate
            case .wet: return .Tyre.wet
            case .undefined: return .primary
            }
        }

        var name: String {
            switch self {
            case .soft: return "Soft"
            case .medium: return "Medium"
            case .hard: return "Hard"
            case .intermediate: return "Inter"
            case .wet: return "Wet"
            case .undefined: return "N/D"
            }
        }
        
        var thicker: String {
            switch self {
            case .soft: return "S"
            case .medium: return "M"
            case .hard: return "H"
            case .intermediate: return "I"
            case .wet: return "W"
            case .undefined: return "N/D"
            }
        }
    }
    
    convenience init(tyre: LivePosition.Tyre, constructorId: String) {
        
        
        let tyreStyle: Tyre
        
        switch tyre {
        case .undefined:
            tyreStyle = .undefined
        case .wet:
            tyreStyle = .wet
        case .intermediate:
            tyreStyle = .intermediate
        case .hard:
            tyreStyle = .hard
        case .medium:
            tyreStyle = .medium
        case .soft:
            tyreStyle = .soft
        }
        
        self.init(tyre: tyreStyle, constructorId: constructorId)
    }
}
