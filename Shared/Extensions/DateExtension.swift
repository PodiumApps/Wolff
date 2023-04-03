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


extension DateFormatter {
    
    static let standard: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssssZ"
        return dateFormatter
    }()

    static let session: DateFormatter = {
        var timeZone = TimeZone.current

        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, hh:mm a"
        dateFormatter.timeZone = timeZone
        
        return dateFormatter
    }()
}
