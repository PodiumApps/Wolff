import Foundation

protocol SessionStandingsListViewModelRepresentable {

    var state: SessionStandingsListViewModel.State { get }
}

final class SessionStandingsListViewModel: SessionStandingsListViewModelRepresentable {

    private let sessionID: Session.ID
    private let liveEventService: LiveSessionServiceRepresentable
    private let networkManager: NetworkManagerRepresentable

    @Published var state: State
    @Published private var cells: [DriverStandingCellViewModel]

    init(
        sessionID: Session.ID,
        liveEventService: LiveSessionServiceRepresentable,
        networkManager: NetworkManagerRepresentable
    ) {

        self.sessionID = sessionID
        self.liveEventService = liveEventService
        self.networkManager = networkManager

        self.state = .loading
        self.cells = []

        self.setUpServices()
    }

    private func setUpServices() {

    }
}

extension SessionStandingsListViewModel {

    enum State: Equatable {

        case loading
        case results([DriverStandingCellViewModel])
        case error(String)

        enum Identifier {

            case loading
            case results
            case error
        }

        var id: Identifier {
            switch self {
            case .loading: return .loading
            case .results: return .results
            case .error: return .error
            }
        }

        static func == (
            lhs: SessionStandingsListViewModel.State,
            rhs: SessionStandingsListViewModel.State
        ) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension SessionStandingsListViewModel {

    static func make(sessionID: Session.ID) -> SessionStandingsListViewModel {

        .init(
            sessionID: sessionID,
            liveEventService: ServiceLocator.shared.liveSessionService,
            networkManager: NetworkManager.shared
        )
    }
}
