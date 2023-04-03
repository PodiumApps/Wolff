import Foundation

protocol LiveSessionCellViewModelRepresentable {

    var sessionName: String { get }
    var podium: [String] { get }
}

final class LiveSessionCellViewModel: LiveSessionCellViewModelRepresentable {

    var sessionName: String
    var podium: [String]

    init(sessionName: String, podium: [String]) {

        self.sessionName = sessionName
        self.podium = podium
    }
}
