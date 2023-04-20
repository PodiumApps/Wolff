import Foundation

protocol SessionStandingsListViewModelRepresentable {

    var state: SessionStandingsListViewModel.State { get }
}

final class SessionStandingsListViewModel: SessionStandingsListViewModelRepresentable {

    private let sessionID: Session.ID
    private var drivers: [Driver]
    private var constructors: [Constructor]

    private let liveEventService: LiveSessionServiceRepresentable
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let networkManager: NetworkManagerRepresentable

    @Published var state: State
    @Published private var cells: [DriverStandingCellViewModel]

    init(
        sessionID: Session.ID,
        liveEventService: LiveSessionServiceRepresentable,
        driverAndConstructorService: DriverAndConstructorServiceRepresentable,
        networkManager: NetworkManagerRepresentable
    ) {

        self.sessionID = sessionID
        self.liveEventService = liveEventService
        self.driverAndConstructorService = driverAndConstructorService
        self.networkManager = networkManager

        self.state = .loading
        self.cells = []

        self.setUpServices()
    }

    private func setUpServices() {

        liveEventService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] liveEventService -> SessionStandingsListViewModel.State? in

                guard let self else { return nil}

                switch liveEventService {
                case .refreshed(let liveSession):

                    guard !liveSession.standings.isEmpty else {

                        Task { await self.buildFinishedStandingsCells() }
                        return nil
                    }

                    return buildStandingsCells(standings: liveSession.standings)

                case .refreshing:
                    return .loading
                case .error(let error):
                    return .error(error.localizedDescription)
                }
            }
            .assign(to: &$state)

        driverAndConstructorService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] driverAndConstructorService -> SessionStandingsListViewModel.State? in

                guard let self else { return nil }

                switch driverAndConstructorService {
                case .refreshed(let drivers, let constructors):

                    self.drivers = drivers
                    self.constructors = constructors
                case .refreshing:
                    return .loading
                case .error(let error):
                    return .error(error.localizedDescription)
                }
            }
            .assign(to: &$state)
    }

    private func buildStandingsCells(standings: [LiveSession.Position]) -> State {

        let cells: [DriverStandingCellViewModel] = standings.compactMap { position in

            let driver = self.drivers.first(where: { $0.id == position.id })

            guard let driver else {   }

            return .init(
                firstName: driver.fullName,
                lastName: driver.lastName,
                team: driver.constructorId,
                position: position.position,
                time: position.time,
                carNumber: driver.carNumber,
                tyre: position.tyre
            )
        }

        return .results([])
    }

    private func buildFinishedStandingsCells() async {

//        let sessionDetails = try? await networkManager.load(SessionDetail.getSession(id: sessionID.string))

        self.state = .results([])
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
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService,
            networkManager: NetworkManager.shared
        )
    }
}
