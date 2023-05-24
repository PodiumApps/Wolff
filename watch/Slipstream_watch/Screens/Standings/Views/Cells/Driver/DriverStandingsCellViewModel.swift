import Foundation

protocol DriverStandingsCellViewModelRepresentable {

    var name: String { get }
    var constructor: String { get }
    var points: Int { get }
    var carNumber: Int { get }
}

final class DriverStandingsCellViewModel: DriverStandingsCellViewModelRepresentable {

    let name: String
    let constructor: String
    let points: Int
    let carNumber: Int

    init(driver: Driver, constructor: Constructor) {

        self.name = driver.fullName
        self.constructor = constructor.name
        self.points = driver.points
        self.carNumber = driver.carNumber
    }

}


