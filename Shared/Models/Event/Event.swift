import Foundation

struct Event: Decodable {

}

extension Event {

    enum Status {
        case upcoming(details: String)
        case current(title: String, details: String)
        case live(title: String, details: String)
        case finished(drivers: [DriverResult])
    }
}
