import Foundation

protocol DriverStandingCellViewModelRepresentable {

    var firstName: String { get }
    var lastName: String { get }
    var team: Constructor { get }
    var position: Int { get }
    var time: String? { get }
    var carNumber: Int { get }
    var tyre: SessionResult.Tyre { get }
}

final class DriverStandingCellViewModel: DriverStandingCellViewModelRepresentable {

    let firstName: String
    let lastName: String
    let team: Constructor
    let position: Int
    let time: String?
    let carNumber: Int
    var tyre: SessionResult.Tyre

    init(
        firstName: String,
        lastName: String,
        team: Constructor,
        position: Int,
        time: String?,
        carNumber: Int,
        tyre: SessionResult.Tyre
    ) {

        self.firstName = firstName
        self.lastName = lastName
        self.team = team
        self.position = position
        self.time = time
        self.carNumber = carNumber
        self.tyre = tyre
    }
}

