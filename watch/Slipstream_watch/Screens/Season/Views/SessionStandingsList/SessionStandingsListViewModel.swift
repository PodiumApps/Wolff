import Foundation
import Combine

protocol SessionStandingsListViewModelRepresentable: ObservableObject {

    var state: SessionStandingsListViewModel.State { get }
    var cells: [DriverStandingCellViewModel] { get }
}

final class SessionStandingsListViewModel: SessionStandingsListViewModelRepresentable {

    private let sessionID: Session.ID
    private var drivers: [Driver]
    private var constructors: [Constructor]

    private let liveEventService: LiveSessionServiceRepresentable
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let networkManager: NetworkManagerRepresentable

    private var subscribers = Set<AnyCancellable>()

    @Published var state: State
    @Published var cells: [DriverStandingCellViewModel]

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
        self.drivers = []
        self.constructors = []
        self.cells = []

        self.setUpServices()
    }

    private func setUpServices() {

        liveEventService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] liveEventService in

                guard let self else { return }

                switch liveEventService {
                case .refreshed(let liveSession):

                    if self.sessionID.string == liveSession.id && !liveSession.standings.isEmpty {

                        self.state = buildLiveStandingsCells(standings: liveSession.standings)
                    } else {

                        Task { @MainActor [weak self] in
                            guard let self else { return }

                            do {
                                let standings = try await self.networkManager
                                    .load(SessionDetail.getSession(for: SessionDetail.self, id: self.sessionID.string))

                                self.state = self.buildFinishedSessionCells(standings: standings)
                            } catch {

                                self.state = .error(error.localizedDescription)
                            }
                        }
                    }
                case .refreshing:
                    self.state = .loading
                case .error(let error):
                    self.state = .error(error.localizedDescription)
                }
            }
            .store(in: &subscribers)

        driverAndConstructorService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] driverAndConstructorService -> SessionStandingsListViewModel.State? in

                guard let self else { return nil }

                switch driverAndConstructorService {
                case .refreshed(let drivers, let constructors):

                    self.drivers = drivers
                    self.constructors = constructors
                    return .loading
                    
                case .refreshing:
                    return .loading
                case .error(let error):
                    return .error(error.localizedDescription)
                }
            }
            .assign(to: &$state)

//        liveEventService.action.send(.fetchPositions)
    }

    private func buildLiveStandingsCells(standings: [LiveSession.Position]) -> State {

        cells = standings.compactMap { position in

            let driver = self.drivers.first(where: { $0.id == position.id })

            guard let driver else { return nil }

            return .init(
                driverID: driver.id,
                firstName: driver.firstName,
                lastName: driver.lastName,
                team: driver.constructorId,
                position: position.position,
                time: position.time != nil ? [position.time!] : [],
                tyre: position.tyre
            )
        }

        return .results(cells)
    }

    private func buildFinishedSessionCells(standings: [SessionDetail]) -> State {

        cells = standings.compactMap { position in

            let driver = self.drivers.first(where: { $0.id == position.driverId })

            guard let driver else { return nil }

            return .init(
                driverID: driver.id,
                firstName: driver.firstName,
                lastName: driver.lastName,
                team: driver.constructorId,
                position: position.position,
                time: position.time,
                tyre: nil
            )
        }

        return .results(cells)
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
