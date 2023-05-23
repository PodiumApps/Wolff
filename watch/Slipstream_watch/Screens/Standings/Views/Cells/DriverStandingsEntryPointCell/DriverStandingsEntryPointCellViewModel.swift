import SwiftUI
import Foundation

protocol DriverStandingsEntryPointCellViewModelRepresentable: ObservableObject {

    var selection: DriverStandingsEntryPointCellViewModel.Selection { get set }

    func tapCell() -> Void
}

final class DriverStandingsEntryPointCellViewModel: DriverStandingsEntryPointCellViewModelRepresentable {

    @State var selection: Selection
    
    private let navigation: StandingsNavigation

    private let drivers: [Driver]
    private let constructors: [Constructor]

    init(navigation: StandingsNavigation, drivers: [Driver], constructor: [Constructor]) {

        self.navigation = navigation
        self.drivers = drivers
        self.constructors = constructor

        self.selection = .drivers
    }

    func tapCell() {
        
        navigation.action.send(.goTo(route: .driversStandingsListView))
    }
}

extension DriverStandingsEntryPointCellViewModel {

    enum Selection: String, Identifiable, CaseIterable {

        case drivers
        case constructors

        static var allCases: [Self] {
            return [.drivers, .constructors]
        }

        var id: String {
            switch self {
            case .drivers: return "Drivers"
            case .constructors: return "Constructors"
            }
        }
    }

    enum Action {

        case tap
    }
}
