import Foundation

protocol DriverStandingCellViewModelRepresentable: ObservableObject {

    var driverID: Driver.ID { get }
    var firstName: String { get }
    var lastName: String { get }
    var team: Constructor.ID { get }
    var position: Int { get }
    var time: [String] { get }
    var tyre: SessionResult.Tyre? { get }
}

final class DriverStandingCellViewModel: DriverStandingCellViewModelRepresentable {

    let driverID: Driver.ID
    let firstName: String
    let lastName: String
    let team: Constructor.ID
    let position: Int
    let time: [String]
    let tyre: SessionResult.Tyre?

    init(
        driverID: Driver.ID,
        firstName: String,
        lastName: String,
        team: Constructor.ID,
        position: Int,
        time: [String],
        tyre: SessionResult.Tyre?
    ) {

        self.driverID = driverID
        self.firstName = firstName
        self.lastName = lastName
        self.team = team
        self.position = position
        self.time = time
        self.tyre = tyre
    }
}

