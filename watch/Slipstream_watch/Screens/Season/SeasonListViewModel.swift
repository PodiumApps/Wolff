import Foundation
import Combine
import OSLog

protocol SeasonListViewModelRepresentable: ObservableObject {

    var state: SeasonListViewModel.State { get }
    var route: [SeasonListViewModel.Route] { get set }
    var action: PassthroughSubject<SeasonListViewModel.Action, Never> { get }
    var indexFirstToAppear: Int { get set }
}

final class SeasonListViewModel: SeasonListViewModelRepresentable {

    private var firstReload: Bool = true

    // Models

    private var drivers: [Driver]
    private var constructors: [Constructor]
    private var events: [Event]
    private var nextEvent: Event?

    // Services

    private let eventService: EventServiceRepresentable
    private let driversAndConstructorService: DriverAndConstructorServiceRepresentable
    private let liveEventService: LiveSessionServiceRepresentable

    // Timer

    private let fiveMinutesInSeconds: Double = 5 * 60
    private var updateAllEventsTimer: Timer? = nil

    private let oneMinuteInSeconds: Double = 60
    private var liveEventTimer: Timer? = nil

    // Published / Combine

    private var subscriptions = Set<AnyCancellable>()
    var action = PassthroughSubject<Action, Never>()
    @Published var state: SeasonListViewModel.State
    @Published var route: [SeasonListViewModel.Route]

    @Published var indexFirstToAppear: Int = 0

    var eventCells: [Cell]

    init(
        driversAndConstructorService: DriverAndConstructorServiceRepresentable,
        eventService: EventServiceRepresentable,
        liveEventService: LiveSessionServiceRepresentable
    ) {

        self.drivers = []
        self.constructors = []
        self.events = []
        self.nextEvent = nil

        self.eventService = eventService
        self.driversAndConstructorService = driversAndConstructorService
        self.liveEventService = liveEventService

        self.state = .loading
        self.route = []

        self.eventCells = []

        self.loadEvents()
    }

    // MARK: - Private

    private func loadEvents() {

        eventService.action.send(.fetchAll)

        eventService.statePublisher
            .combineLatest(driversAndConstructorService.statePublisher)
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] eventService, driversAndConstructorService -> SeasonListViewModel.State? in

                guard let self else { return nil }

                switch (eventService, driversAndConstructorService) {
                case (.error(let error), _), (_, .error(let error)):
                    return .error(error.localizedDescription)

                case (.refreshed(let events), .refreshed(let drivers, let constructors)):

                    self.constructors = constructors
                    self.drivers = drivers
                    self.events = events

                    return self.buildAllEventCells()

                case (.refreshing, _), (_, .refreshing):
                    return .loading
                }
            }
            .assign(to: &$state)

        liveEventService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] liveEventService in

                guard
                    let self,
                    case .results(var cells) = self.state,
                    let index = cells.firstIndex(where: { $0.id == .live }),
                    case .live(let timeInterval, let sessionName) = self.events[index].status
                else {
                    return nil
                }

                switch liveEventService {
                case .refreshed(let positions):

                    let podium: [String] = positions[0 ..< 3].compactMap { [weak self] position in

                        guard let self else { return nil }

                        guard let driver = self.drivers.first(where: { $0.id == position.id }) else { return nil }
                        return driver.driverTicker
                    }

                    cells[index] = .live(
                        self.buildLiveViewModel(
                            event: self.events[index],
                            timeInterval: timeInterval,
                            sessionName: sessionName,
                            podium: podium
                        )
                    )

                    return .results(cells)

                case .refreshing, .error:

                    cells[index] = .live(
                        self.buildLiveViewModel(
                            event: self.events[index],
                            timeInterval: timeInterval,
                            sessionName: sessionName
                        )
                    )

                    return .results(cells)
                }
            }
            .assign(to: &$state)
    }

    private func updateLiveEventTimer(timeInterval: TimeInterval, triggerInterval: Double) {

        liveEventTimer?.invalidate()

        liveEventTimer =
        Timer.scheduledTimer(withTimeInterval: triggerInterval, repeats: true) { [weak self, timeInterval] _ in

                guard let self else { return }

                if timeInterval < .minuteInterval {

                    self.liveEventService.action.send(.updatePositions)
                }

                self.state = self.buildAllEventCells()
        }
    }

    private func buildAllEventCells() -> State {

        eventCells = events.compactMap { event in
            switch event.status {
            case .live(let timeInterval, let sessionName):

                updateLiveEventTimer(timeInterval: timeInterval, triggerInterval: 10)

                return .live(
                    buildLiveViewModel(
                        event: event,
                        timeInterval: timeInterval,
                        sessionName: sessionName
                    )
                )
            case .upcoming(let start, let end, let sessionName, let timeInterval):

                if let timeInterval, timeInterval > (4 * .hourInterval) {
                    updateLiveEventTimer(timeInterval: timeInterval, triggerInterval: .minuteInterval)
                }

                return .upcoming(
                    buildUpcomingViewModel(
                        event: event,
                        start: start,
                        end: end,
                        sessionName: sessionName,
                        timeInterval: timeInterval
                    )
                )
            case .finished(let driversOnPodium):

                let tickers: [String] = driversOnPodium.lazy.enumerated().compactMap { index, driverID in

                    guard let driver = drivers.lazy.first(where: { $0.id == driverID }) else { return nil }
                    return driver.driverTicker
                }

                return .finished(
                    buildFinishedCardViewModel(
                        event: event,
                        podium: tickers
                    )
                )
            }
        }

        for (index, cell) in eventCells.enumerated() {
            switch cell {
            case .live, .upcoming:
                indexFirstToAppear = index
                return .results(eventCells)
            case .finished:
                continue
            }
        }

        return .results(eventCells)
    }

    private func buildLiveViewModel(
        event: Event,
        timeInterval: TimeInterval,
        sessionName: String,
        podium: [String]? = nil
    ) -> LiveEventCardViewModel {

        return LiveEventCardViewModel(
            id: event.id,
            title: event.title,
            country: event.country,
            round: event.round,
            timeInterval: timeInterval,
            sessionName: sessionName,
            podium: podium,
            state: setUpLiveEventState(podium: podium, timeInterval: timeInterval)
        )
    }

    private func buildUpcomingViewModel(
        event: Event,
        start: String,
        end: String,
        sessionName: String,
        timeInterval: TimeInterval?
    ) -> UpcomingEventCardViewModel {

        return UpcomingEventCardViewModel(
            id: event.id,
            title: event.title,
            country: event.country,
            round: event.round,
            start: start,
            end: end,
            sessionName: sessionName,
            timeInterval: timeInterval
        )
    }

    private func buildFinishedCardViewModel(
        event: Event,
        podium: [String]
    ) -> FinishedEventCardViewModel {

        return FinishedEventCardViewModel(
            id: event.id,
            title: event.title,
            country: event.country,
            round: event.round,
            podium: podium
        )
    }

    private func setUpLiveEventState(podium: [String]?, timeInterval: TimeInterval) -> LiveEventCardViewModel.State {

        guard let podium, timeInterval <= 0 else {

            if timeInterval < .minuteInterval { return .aboutToStart }

            let timeToStart = timeInterval.hoursAndMinutes

            return
                .betweenOneMinuteAndFourHoursToGo(
                    hours: timeToStart.hours,
                    minutes: timeToStart.minutes
                )
        }

        return .happeningNow(podium: podium)
    }
}

extension SeasonListViewModel {

    enum Cell: Hashable, Identifiable {
        
        case live(LiveEventCardViewModel)
        case upcoming(UpcomingEventCardViewModel)
        case finished(FinishedEventCardViewModel)

        var id: Identifier {

            switch self {
            case .live: return .live
            case .upcoming(let viewModel): return .upcoming(viewModel.id.string)
            case .finished(let viewModel): return .finished(viewModel.id.string)
            }
        }

        enum Identifier: Hashable {

            case live
            case upcoming(String)
            case finished(String)
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension SeasonListViewModel {

    enum Action {

        case tap(index: Int)
    }

    enum State: Equatable {

        static func == (
            lhs: SeasonListViewModel.State,
            rhs: SeasonListViewModel.State
        ) -> Bool {
            lhs.id == rhs.id
        }

        case error(String)
        case results([Cell])
        case loading

        enum Identifier: String {

            case error
            case loading
            case results
        }

        var id: Identifier {

            switch self {
            case .loading: return .loading
            case .results: return .results
            case .error: return .error
            }
        }
    }

    enum Route: Hashable {

        case sessionStandings // SessionStandingsViewModel

        static func == (
            lhs: SeasonListViewModel.Route,
            rhs: SeasonListViewModel.Route
        ) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: String {
            switch self {
            case .sessionStandings: return "sessionStandings"
            }
        }
    }
}

extension SeasonListViewModel {

    static func make() -> SeasonListViewModel {

        .init(
            driversAndConstructorService: ServiceLocator.shared.driverAndConstructorService,
            eventService: ServiceLocator.shared.eventService,
            liveEventService: ServiceLocator.shared.liveSessionService
        )
    }
}
