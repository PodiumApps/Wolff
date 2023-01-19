import Foundation

protocol ResultCardRepresentable {

    var sessionType: Session.Name { get }
    var fastestLap: String { get }
    var drivers: [DriverResult] { get }
}

final class ResultCardViewModel: ResultCardRepresentable {

    let sessionType: Session.Name
    let fastestLap: String
    let drivers: [DriverResult]

    init(sessionType: Session.Name, fastestLap: String, drivers: [DriverResult]) {

        self.sessionType = sessionType
        self.fastestLap = fastestLap
        self.drivers = drivers.sorted(by: { $1.value.order < $0.value.order })
    }
}
