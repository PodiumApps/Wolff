import Foundation
import Combine

protocol SessionListViewModelRepresentable {

    var state: SessionListViewModel.State { get }
}

final class SessionListViewModel: SessionListViewModelRepresentable {

    private let event: Event
    private var constructors: [Constructor]
    private var drivers: [Driver]

    private let eventService: EventServiceRepresentable
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable

    @Published var state: State
    @Published private var sessionCells: [Cell]

    init(
        event: Event,
        eventService: EventServiceRepresentable,
        driverAndConstructorService: DriverAndConstructorServiceRepresentable
    ) {

        self.event = event
        self.drivers = []
        self.constructors = []

        self.eventService = eventService
        self.driverAndConstructorService = driverAndConstructorService

        self.state = .loading
        self.sessionCells = []

        self.state = buildSessionRows()

        self.setUpServices()
    }

    private func setUpServices() {

        eventService.statePublisher
            .combineLatest(driverAndConstructorService.statePublisher)
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] eventService, driverAndConstructorService -> SessionListViewModel.State? in

                guard let self else { return nil }

                switch (eventService, driverAndConstructorService) {
                case (.error(let error), _), (_, .error(let error)):
                    return .error(error.localizedDescription)
                case (_, .refreshed(let drivers, let constructors)):

                    self.constructors = constructors
                    self.drivers = drivers

                    return self.buildSessionRows()

                case (.refreshing, _), (_, .refreshing):
                    return .loading
                }
            }
            .assign(to: &$state)
    }

    private func buildSessionRows() -> State {

        var liveEventCellBuilt = false

        sessionCells = event.sessions.compactMap { session in

            if case .live(let timeInterval, _) = event.status {
                if session.winners.isEmpty && !liveEventCellBuilt {
                    liveEventCellBuilt = true
                    return .live(
                        buildLiveSessionCellViewModel(
                            sessionName: session.name,
                            sessionDate: session.date,
                            timeInterval: timeInterval
                        )
                    )
                }
            }

            if session.winners.isEmpty {
                return .upcoming(
                    buildUpcomingSessionCellViewModel(
                        sessionName: session.name, date: session.date
                    )
                )
            } else {
                return .finished(
                    buildFinishedSessionCellViewModel(
                        sessionName: session.name, podium: session.winners
                    )
                )
            }
        }

        return .results(sessionCells)
    }

    private func buildUpcomingSessionCellViewModel(sessionName: Session.Name, date: Date) -> UpcomingSessionCellViewModel {

        return UpcomingSessionCellViewModel(
            sessionName: sessionName.label,
            date: date
        )
    }

    private func buildLiveSessionCellViewModel(
        sessionName: Session.Name,
        podium: [Driver.ID]? = nil,
        sessionDate: Date,
        timeInterval: TimeInterval
    ) -> LiveSessionCellViewModel {

        return LiveSessionCellViewModel(
            sessionName: sessionName.label,
            state: setUpLiveSessionState(podium: podium, date: sessionDate, timeInterval: timeInterval)
        )
    }

    private func buildFinishedSessionCellViewModel(sessionName: Session.Name, podium: [Driver.ID]) -> FinishedSessionCellViewModel {

        return FinishedSessionCellViewModel(
            session: sessionName.label,
            winners: getPodiumTickers(podium: podium)
        )
    }

    private func getPodiumTickers(podium: [Driver.ID]) -> [String] {

        let tickers: [String] = podium.lazy.enumerated().compactMap { index, driverID in

            guard let driver = drivers.lazy.first(where: { $0.id == driverID }) else { return nil }
            return driver.fullName
        }

        return tickers
    }

    private func setUpLiveSessionState(
        podium: [Driver.ID]?,
        date: Date,
        timeInterval: TimeInterval
    ) -> LiveSessionCellViewModel.State {

        guard let podium, timeInterval <= 0 else {

            if timeInterval < .minuteInterval { return .aboutToStart }

            let timeToStart = timeInterval.hoursAndMinutes

            return
                .betweenOneMinuteAndFourHoursToGo(
                    date: date
                )
        }

        let driverTickers = getPodiumTickers(podium: podium)
        return .happeningNow(podium: driverTickers)
    }
}

extension SessionListViewModel {

    enum State: Equatable {

        case loading
        case results([Cell])
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
    }

    enum Cell: Equatable, Identifiable {

        case upcoming(UpcomingSessionCellViewModel)
        case live(LiveSessionCellViewModel)
        case finished(FinishedSessionCellViewModel)

        enum Identifier {

            case upcoming
            case live
            case finished
        }

        var id: Identifier {

            switch self {
            case .upcoming: return .upcoming
            case .live: return .live
            case .finished: return .finished
            }
        }

        static func == (lhs: SessionListViewModel.Cell, rhs: SessionListViewModel.Cell) -> Bool {
            lhs.id == rhs.id
        }
    }

    enum Action {

        case tap(Int)
    }
}

extension SessionListViewModel {

    static func make(event: Event) -> SessionListViewModel {
        .init(
            event: event,
            eventService: ServiceLocator.shared.eventService,
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService
        )
    }
}
