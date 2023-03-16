import Foundation

extension Int {
    
    var getPositionString: String {
        switch self {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return ""
        }
    }
    
}
