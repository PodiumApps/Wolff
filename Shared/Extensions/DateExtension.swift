import Foundation
import CryptoKit

extension Date {

    var tokenString: String {

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "dd:HH"

        let token = formatter.string(from: self) + "tomasmamede.com.Slipstream"

        guard let data = token.data(using: .utf8) else {
            fatalError("Token Error")
        }

        return SHA512.hash(data: data).description
            .replacingOccurrences(of: "SHA512 digest:", with: "")
    }
}

// Get date components
extension Date {
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension DateFormatter {
    
    static let standard: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssssZ"
        return dateFormatter
    }()
}
