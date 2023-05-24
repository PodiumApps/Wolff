import Foundation

protocol DriverStandingsDetailsViewModelRepresentable {

    var state: DriverStandingsDetailsViewModel.State { get }
    func loadDriverDetails(driver: Driver.ID) async
}

final class DriverStandingsDetailsViewModel: DriverStandingsDetailsViewModelRepresentable {

    var state: State

    private let driverID: Driver.ID
    private let networkManager: NetworkManagerRepresentable

    init(driverID: Driver.ID, networkManager: NetworkManagerRepresentable) {

        self.state = .loading
        
        self.driverID = driverID
        self.networkManager = networkManager
    }

    @MainActor func loadDriverDetails(driver: Driver.ID) async {

        do {

            let details = try await self.networkManager.load(DriverDetails.getDetails(for: driverID.string))
            
            self.buildInfoComponents(details: details)
        } catch {

            self.state = .error(error.localizedDescription)
        }
    }

    private func buildInfoComponents(details: DriverDetails) {

        self.state = .results([
            (key: Localization.DriverDetails.placeOfBirth, value: details.placeOfBirth),
            (key: Localization.DriverDetails.championships, value: details.championships.description),
            (key: Localization.DriverDetails.numberOfPodiums, value: details.podiums.description),
            (key: Localization.DriverDetails.grandPrixEntered, value: details.grandPrixEntered.description),
            (key: Localization.DriverDetails.highestGridPosition, value: details.highestGridPos.description),
            (key: Localization.DriverDetails.allTimePoints, value: details.allTimePoints.description)
        ])
    }
}

extension DriverStandingsDetailsViewModel {

    enum State: Equatable {

        case error(String)
        case loading
        case results([(key: String, value: String)])

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

    static func make(driverID: Driver.ID) -> DriverStandingsDetailsViewModel {

        .init(driverID: driverID, networkManager: NetworkManager.shared)
    }
}
