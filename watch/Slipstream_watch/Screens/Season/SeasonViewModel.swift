import Foundation
import Combine
import OSLog

protocol SeasonListViewModelRepresentable: ObservableObject {

    var state: SeasonListViewModel.State { get }
    var route: [SeasonListViewModel.Route] { get set }
    var action: PassthroughSubject<SeasonListViewModel.Action, Never> { get }
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

    private var timer: Timer? = nil
    private var timerEvents: Timer? = nil
    private var timesToRefreshEvent: Int = 0

    // Published / Combine

    private var subscriptions = Set<AnyCancellable>()
    var action = PassthroughSubject<Action, Never>()
    @Published var state: SeasonListViewModel.State
    @Published var route: [SeasonListViewModel.Route]

    var liveEvents: [Cell]

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

        self.liveEvents = []

        // loadEvents()
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

                    return .results

                case (.refreshing, _), (_, .refreshing):
                    return .loading
                }
            }
            .assign(to: &$state)

        liveEvents = events.compactMap { event in
            switch event.status {
            case .live(let timeInterval, let sessionName):
                return .live(
                    buildLiveViewModel(
                        event: event,
                        timeInterval: timeInterval,
                        sessionName: sessionName
                    )
                )
            case .upcoming(let start, let end, let sessionName, let timeInterval?):
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
            default:
                return .finished(
                    buildFinishedCardViewModel(
                        event: event,
                        podium: []
                    )
                )
            }
        }
    }

    private func buildLiveViewModel(
        event: Event,
        timeInterval: TimeInterval,
        sessionName: String
    ) -> LiveEventCardViewModel {

        return LiveEventCardViewModel(
            id: event.id,
            title: event.title,
            country: event.country,
            round: event.round,
            timeInterval: timeInterval,
            sessionName: sessionName
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
}

extension SeasonListViewModel {

    enum Cell: Hashable, Identifiable {
        
        case live(LiveEventCardViewModel)
        case upcoming(UpcomingEventCardViewModel)
        case finished(FinishedEventCardViewModel)

        enum Identifier {

            case live
            case upcoming
            case finished
        }

        var id: Identifier {

            switch self {
            case .live: return .live
            case .upcoming: return .upcoming
            case .finished: return .finished
            }
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
        case results
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





