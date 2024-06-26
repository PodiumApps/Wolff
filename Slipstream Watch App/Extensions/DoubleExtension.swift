import Foundation

extension Double {

    var roundedString: String { String(format: "%.2f", self) }

    static let minuteInterval: Self = 60
    static let weekInterval: Self = 7*24*Double.hourInterval
    static let dayInterval: Self = 24*Double.hourInterval
    static let liveInSeconds: Self = 4*Double.hourInterval
    static let threeDaysInterval: Self = 2*24*Double.hourInterval
    
    static let maximumSessionTime: Self = 4.5*Double.hourInterval
    
    static let hourInterval: Self = 60*60
}
