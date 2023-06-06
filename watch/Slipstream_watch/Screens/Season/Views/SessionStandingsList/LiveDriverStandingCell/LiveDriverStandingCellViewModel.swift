import Foundation
import Combine

protocol LiveDriverStandingCellViewModelRepresentable: ObservableObject {

    var driverID: Driver.ID { get }
    var firstName: String { get }
    var lastName: String { get }
    var constructor: Constructor { get }
    var position: Int { get }
    var time: [String] { get }
    var tyre: SessionResult.Tyre? { get }
    var showDriverSessionDetails: Bool { get set }
    var action: PassthroughSubject<LiveDriverStandingCellViewModel.Action, Never> { get }
}

final class LiveDriverStandingCellViewModel: LiveDriverStandingCellViewModelRepresentable {

    let driverID: Driver.ID
    let firstName: String
    let lastName: String
    let constructor: Constructor
    let position: Int
    let time: [String]
    let tyre: SessionResult.Tyre?

    @Published var showDriverSessionDetails: Bool = false

    var action = PassthroughSubject<Action, Never>()
    private var subscribers = Set<AnyCancellable>()

    init(
        driverID: Driver.ID,
        firstName: String,
        lastName: String,
        team: Constructor,
        position: Int,
        time: [String],
        tyre: SessionResult.Tyre?
    ) {

        self.driverID = driverID
        self.firstName = firstName
        self.lastName = lastName
        self.constructor = team
        self.position = position
        self.time = time
        self.tyre = tyre

        self.setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .showLiveDriverDetails:
                    showDriverSessionDetails.toggle()
                }
            }
            .store(in: &subscribers)
    }
}

extension LiveDriverStandingCellViewModel {

    enum Action {

        case showLiveDriverDetails
    }
}

