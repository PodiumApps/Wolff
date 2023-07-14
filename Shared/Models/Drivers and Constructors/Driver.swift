import Foundation

struct Driver: Codable, Identifiable, Hashable {
    
    typealias ID = Identifier<Driver>

    let id: ID
    let carNumber: Int
    let firstName: String
    let lastName: String
    let driverTicker: String
    let position: Int
    let points: Int
    let constructorId: Constructor.ID
    
    var fullName: String { firstName + " " + lastName }
}

extension Driver {

    static func getDrivers() -> Resource<[Self]> {

        guard let url = URL(string: "\(Global.url)/v1/drivers") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
    
    static func getDriver(id: String) -> Resource<Self> {

        guard let url = URL(string: "\(Global.url)/v1/driver/\(id)") else { fatalError("URL not found.") }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }

    static func getPodiumDriverTickers(podium: [Driver.ID], drivers: [Driver]) -> [String] {

        let tickers: [String] = podium.lazy.enumerated().compactMap { index, driverID in

            guard let driver = drivers.lazy.first(where: { $0.id == driverID }) else { return nil }
            return driver.driverTicker
        }

        return tickers
    }

    static func getPodiumDriverFullName(podium: [Driver.ID], drivers: [Driver]) -> [String] {

        let tickers: [String] = podium.lazy.enumerated().compactMap { index, driverID in

            guard let driver = drivers.lazy.first(where: { $0.id == driverID }) else { return nil }
            return driver.fullName
        }

        return tickers
    }
}
