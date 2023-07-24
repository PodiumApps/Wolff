import Foundation
import Combine

protocol SessionListViewModelRepresentable: ObservableObject {

    var state: SessionListViewModel.State { get }
}

final class SessionListViewModel: SessionListViewModelRepresentable {

    private let event: Event
    private var constructors: [Constructor]
    private var drivers: [Driver]

    private let eventService: EventServiceRepresentable
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let liveEventService: LiveSessionServiceRepresentable
    private let navigation: AppNavigationRepresentable
    private var subscriptions = Set<AnyCancellable>()

    @Published var state: State
    @Published private var sessionCells: [Cell]

    init(
        event: Event,
        eventService: EventServiceRepresentable,
        driverAndConstructorService: DriverAndConstructorServiceRepresentable,
        liveEventService: LiveSessionServiceRepresentable,
        navigation: AppNavigationRepresentable
    ) {

        self.event = event
        self.drivers = []
        self.constructors = []

        self.eventService = eventService
        self.driverAndConstructorService = driverAndConstructorService
        self.liveEventService = liveEventService
        
        self.navigation = navigation

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

        liveEventService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] liveEventService -> SessionListViewModel.State? in

                guard
                    let self,
                    case .results(var sections) = self.state,
                    let sectionIndex = sections.firstIndex(where: { $0.id == .cells }),
                    case .cells(let cells) = sections[sectionIndex],
                    let index = cells.firstIndex(where: { $0.id == .live }),
                    case .live(let timeInterval, _) = event.status
                else {
                    return nil
                }

                switch liveEventService {
                case .refreshed(let liveSession):

                    let positions = liveSession.standings
                    guard !positions.isEmpty else { return nil }

                    let podium: [Driver.ID] = positions[0 ..< 3].compactMap { [weak self] position in

                        guard let self else { return nil }

                        guard let driver = self.drivers.first(where: { $0.id == position.id }) else { return nil }
                        return driver.id
                    }

                    sessionCells[index] = .live(
                        buildLiveSessionCellViewModel(
                            sessionName: event.sessions[index].name,
                            sessionDate: event.sessions[index].date,
                            sessionID: event.sessions[index].id,
                            podium: podium,
                            status: liveSession.status,
                            timeInterval: timeInterval
                        )
                    )

                    sections[sectionIndex] = .cells(sessionCells)
                    return .results(sections)

                case .refreshing, .error:

                    sections[sectionIndex] = .cells(sessionCells)
                    return .results(sections)
                }
            }
            .assign(to: &$state)
    }

    private func buildSessionRows() -> State {

        let trackInfoCellViewModel: TrackInfoCellViewModel = .init(event: event)

        var liveEventCellBuilt = false

        sessionCells = event.sessions.compactMap { session in

            if case .live(let timeInterval, _) = event.status {
                if session.winners.isEmpty && !liveEventCellBuilt {
                    liveEventCellBuilt = true

                    return .live(
                        buildLiveSessionCellViewModel(
                            sessionName: session.name,
                            sessionDate: session.date,
                            sessionID: session.id,
                            podium: [],
                            status: LiveSession.Status(redFlag: false, state: ""),
                            timeInterval: timeInterval
                        )
                    )
                }
            }

            return session.winners.isEmpty
                ? .upcoming(buildUpcomingSessionCellViewModel(sessionName: session.name, date: session.date))
                : .finished(buildFinishedSessionCellViewModel(
                    sessionID: session.id,
                    sessionName: session.name,
                    podium: session.winners)
                )
        }

        return .results([.header(trackInfoCellViewModel), .cells(sessionCells)])
    }

    private func buildUpcomingSessionCellViewModel(
        sessionName: Session.Name,
        date: Date
    ) -> UpcomingSessionCellViewModel {

        return UpcomingSessionCellViewModel(
            sessionName: sessionName.label,
            date: date
        )
    }

    private func buildLiveSessionCellViewModel(
        sessionName: Session.Name,
        sessionDate: Date,
        sessionID: Session.ID,
        podium: [Driver.ID],
        status: LiveSession.Status,
        timeInterval: TimeInterval
    ) -> LiveSessionCellViewModel {
        
        let viewModel: LiveSessionCellViewModel = .init(
            sessionName: sessionName.label,
            sessionID: sessionID,
            podium: Driver.getPodiumDriverTickers(podium: podium, drivers: drivers),
            state: setUpLiveSessionState(podium: podium, date: sessionDate, timeInterval: timeInterval, status: status)
        )

        return viewModel
    }

    private func buildFinishedSessionCellViewModel(
        sessionID: Session.ID,
        sessionName: Session.Name,
        podium: [Driver.ID]
    ) -> FinishedSessionCellViewModel {

        let sessionStandingsListViewModel = SessionStandingsListViewModel.make(
            sessionID: sessionID,
            sessionName: sessionName.label
        )
        
        let viewModel: FinishedSessionCellViewModel = .init(
            sessionID: sessionID,
            session: sessionName.label,
            winners: Driver.getPodiumDriverFullName(podium: podium, drivers: drivers)
        )
        
        viewModel.action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .tapSession:
                    navigation.action.send(.append(route: .finishedSessionStandingsList(sessionStandingsListViewModel)))
                }
            }
            .store(in: &subscriptions)

        return viewModel
    }

    private func setUpLiveSessionState(
        podium: [Driver.ID]?,
        date: Date,
        timeInterval: TimeInterval,
        status: LiveSession.Status
    ) -> LiveSessionCellViewModel.State {

        guard let podium, timeInterval <= 0 else {

            return timeInterval < .minuteInterval
                ? .aboutToStart
                : .betweenOneMinuteAndFourHoursToGo(date: date)
        }

        let driverTickers = Driver.getPodiumDriverTickers(podium: podium, drivers: drivers)
        return .happeningNow(podium: driverTickers, status: status)
    }
}

extension SessionListViewModel {

    enum State: Equatable {

        case loading
        case results([Section])
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

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }

    enum Section: Equatable, Identifiable {

        case header(TrackInfoCellViewModel)
        case cells([Cell])

        enum Identifier {

            case header
            case cells
        }

        var id: Identifier {

            switch self {
            case .header: return .header
            case .cells: return .cells
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
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

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension SessionListViewModel {

    static func make(event: Event, navigation: AppNavigationRepresentable) -> SessionListViewModel {
        .init(
            event: event,
            eventService: ServiceLocator.shared.eventService,
            driverAndConstructorService: ServiceLocator.shared.driverAndConstructorService,
            liveEventService: ServiceLocator.shared.liveSessionService,
            navigation: navigation
        )
    }
}
