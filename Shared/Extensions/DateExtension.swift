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

    var isSessionToday: Bool {

        return Calendar.current.isDateInToday(self)
    }

    var isSessionTomorrow: Bool {

        return Calendar.current.isDateInTomorrow(self)
    }
}


extension DateFormatter {
    
    static let standard: DateFormatter = {
        var timeZone = TimeZone.current

        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssssZ"
        dateFormatter.timeZone = timeZone
        return dateFormatter
    }()

    static let session: DateFormatter = {
        var timeZone = TimeZone.current

        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d 'at' hh:mm a"
        dateFormatter.timeZone = timeZone
        
        return dateFormatter
    }()

    static let timeForSession: DateFormatter = {
        var timeZone = TimeZone.current

        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = timeZone

        return dateFormatter
    }()

    static let newsDate: DateFormatter = {
        var timeZone = TimeZone.current

        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.timeZone = timeZone

        return dateFormatter
    }()
}
