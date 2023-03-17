import Foundation

extension Double {

    var roundedString: String { String(format: "%.2f", self) }
    
    static let weekInterval: Self = 7*24*60*60
    static let dayInterval: Self = 24*60*60
    static let liveInSeconds: Self = 4*60*60
    static let threeDaysInterval: Self = 3*24*60*60
    
    static let maximumSessionTime: Self = 4*60*60
}
