import Foundation
import SwiftUI

protocol DriverStandingsDetailsViewModelRepresentable: ObservableObject {

    var constructorID: Constructor.ID { get }
    var state: DriverStandingsDetailsViewModel.State { get }
    func loadDriverDetails() async
}

final class DriverStandingsDetailsViewModel: DriverStandingsDetailsViewModelRepresentable {

    @Published var state: State

    let constructorID: Constructor.ID

    private let driverID: Driver.ID
    private let driverName: String
    private let networkManager: NetworkManagerRepresentable

    init(
        driverID: Driver.ID,
        driverName: String,
        constructorID: Constructor.ID,
        networkManager: NetworkManagerRepresentable
    ) {

        self.state = .loading
        
        self.driverID = driverID
        self.constructorID = constructorID
        self.driverName = driverName
        self.networkManager = networkManager
    }

    @MainActor func loadDriverDetails() async {

        do {

            let details = try await self.networkManager.load(DriverDetails.getDetails(for: driverID))
            
            self.buildInfoComponents(details: details)
        } catch {

            self.state = .error(error.localizedDescription)
        }
    }

    private func buildInfoComponents(details: DriverDetails) {

        self.state = .results(
            info: [
                (key: Localization.DriverDetails.placeOfBirth, value: details.placeOfBirth),
                (key: Localization.DriverDetails.championships, value: details.championships.description),
                (key: Localization.DriverDetails.numberOfPodiums, value: details.podiums.description),
                (key: Localization.DriverDetails.grandPrixEntered, value: details.grandPrix.description),
                (key: Localization.DriverDetails.highestGridPosition, value: details.highestGridPos.description),
                (key: Localization.DriverDetails.allTimePoints, value: details.allTimePoints.description)
            ],
            driverName: driverName
        )
    }
}

extension DriverStandingsDetailsViewModel {

    enum State: Equatable {

        case error(String)
        case loading
        case results(info: [(key: String, value: String)], driverName: String)

        enum Identifier {

            case error
            case loading
            case results
        }

        var id: Identifier {
            switch self {
            case .error: return .error
            case .loading: return .loading
            case .results: return .results
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension DriverStandingsDetailsViewModel {

    static func make(
        driverName: String,
        driverID: Driver.ID,
        constructorID: Constructor.ID
    ) -> DriverStandingsDetailsViewModel {

        .init(
            driverID: driverID,
            driverName: driverName,
            constructorID: constructorID,
            networkManager: NetworkManager.shared
        )
    }
}
