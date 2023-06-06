import Foundation
import Combine

protocol DriverStandingsCellViewModelRepresentable: Identifiable, ObservableObject {

    var driverID: Driver.ID { get }
    var firstName: String { get }
    var lastName: String { get }
    var constructor: Constructor { get }
    var points: Int { get }
    var position: Int { get }
    var carNumber: Int { get }
    var showDriverDetailsSheet: Bool { get set }
    var action: PassthroughSubject<DriverStandingsCellViewModel.Action, Never> { get }
}

final class DriverStandingsCellViewModel: DriverStandingsCellViewModelRepresentable {

    let driverID: Driver.ID
    let firstName: String
    var lastName: String
    let constructor: Constructor
    let points: Int
    let position: Int
    let carNumber: Int

    @Published var showDriverDetailsSheet: Bool = false

    var action = PassthroughSubject<DriverStandingsCellViewModel.Action, Never>()
    private var subscribers = Set<AnyCancellable>()

    init(driver: Driver, constructor: Constructor, position: Int) {

        self.driverID = driver.id
        self.firstName = driver.firstName
        self.lastName = driver.lastName
        self.constructor = constructor
        self.points = driver.points
        self.position = position
        self.carNumber = driver.carNumber

        self.setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .openDetailsView:
                    showDriverDetailsSheet.toggle()
                }
            }
            .store(in: &subscribers)
    }
}

extension DriverStandingsCellViewModel {

    enum Action {

        case openDetailsView
    }
}


