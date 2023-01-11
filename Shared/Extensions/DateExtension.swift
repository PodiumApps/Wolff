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
