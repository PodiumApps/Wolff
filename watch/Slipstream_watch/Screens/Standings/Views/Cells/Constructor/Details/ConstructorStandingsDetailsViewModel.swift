import Foundation

protocol ConstructorStandingsDetailsViewModelRepresentable: ObservableObject {

    var state: ConstructorStandingsDetailsViewModel.State { get }
    var constructorID: Constructor.ID { get }
    func loadConstructorDetails() async
}

final class ConstructorStandingsDetailsViewModel: ConstructorStandingsDetailsViewModelRepresentable {

    @Published var state: State

    let constructorID: Constructor.ID

    private let networkManager: NetworkManagerRepresentable
    private let constructorName: String

    init(
        constructorID: Constructor.ID,
        constructorName: String,
        networkManager: NetworkManagerRepresentable
    ) {

        self.state = .loading

        self.constructorID = constructorID
        self.constructorName = constructorName
        self.networkManager = networkManager
    }

    @MainActor func loadConstructorDetails() async {

        do {

            let details = try await self.networkManager.load(ConstructorDetails.getDetails(for: constructorID))

            buildInfoComponents(constructorDetails: details)
        } catch {

            self.state = .error(error.localizedDescription)
        }
    }

    private func buildInfoComponents(constructorDetails: ConstructorDetails) {

        self.state = .results(
            info: [
                (key: "Base", value: constructorDetails.base),
                (key: "First Team Entry", value: constructorDetails.firstTeamEntry.description),
                (key: "World Championships", value: constructorDetails.worldChampionships.description),
                (key: "Technical Chief", value: constructorDetails.technicalChief),
                (key: "Chassis", value: constructorDetails.chassis),
                (key: "Pole Positions", value: constructorDetails.polePositions.description),
                (key: "Fastest Laps", value: constructorDetails.fastestLaps.description)
            ],
            constructorName: constructorName
        )
    }
}

extension ConstructorStandingsDetailsViewModel {

    enum Action {

        case loadConstructorDetails
    }

    enum State: Equatable {

        case error(String)
        case loading
        case results(info: [(key: String, value: String)], constructorName: String)

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

extension ConstructorStandingsDetailsViewModel {

    static func make(constructorID: Constructor.ID, constructorName: String) -> ConstructorStandingsDetailsViewModel {

        .init(constructorID: constructorID, constructorName: constructorName, networkManager: NetworkManager.shared)
    }
}
