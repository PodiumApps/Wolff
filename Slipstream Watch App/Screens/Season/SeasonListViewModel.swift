import SwiftUI
import Combine
import OSLog

protocol SeasonListViewModelRepresentable: ObservableObject {

    var state: SeasonListViewModel.State { get }
    var action: PassthroughSubject<SeasonListViewModel.Action, Never> { get }
}

final class SeasonListViewModel: SeasonListViewModelRepresentable {

    private var firstReload: Bool = true

    private var drivers: [Driver]
    private var constructors: [Constructor]
    private var events: [Event]
    private var nextEvent: Event?

    private let eventService: EventServiceRepresentable
    private let driversAndConstructorService: DriverAndConstructorServiceRepresentable
    private let liveSessionService: LiveSessionServiceRepresentable
    private let purchaseService: PurchaseServiceRepresentable

    private let fiveMinutesInSeconds: Double = 5 * 60

    private let oneMinuteInSeconds: Double = 60
    private var liveEventTimer: Timer? = nil
    
    private var navigation: AppNavigationRepresentable

    private var subscriptions = Set<AnyCancellable>()
    private var subscriptionsPurchase = Set<AnyCancellable>()
    var action = PassthroughSubject<Action, Never>()
    @Published var state: SeasonListViewModel.State

    var eventCells: [Cell]

    init(
        navigation: AppNavigationRepresentable,
        driversAndConstructorService: DriverAndConstructorServiceRepresentable,
        eventService: EventServiceRepresentable,
        liveEventService: LiveSessionServiceRepresentable,
        purchaseService: PurchaseServiceRepresentable
    ) {

        self.navigation = navigation
        self.drivers = []
        self.constructors = []
        self.events = []
        self.nextEvent = nil

        self.eventService = eventService
        self.driversAndConstructorService = driversAndConstructorService
        self.liveSessionService = liveEventService
        self.purchaseService = purchaseService

        self.state = .loading

        self.eventCells = []

        self.setUpBindings()
        self.loadEvents()
    }

    // MARK: - Private

    private func loadEvents() {

        eventService.statePublisher
            .combineLatest(driversAndConstructorService.statePublisher)
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] eventService, driversAndConstructorService -> SeasonListViewModel.State? in

                guard let self else { return nil }

                switch (eventService, driversAndConstructorService) {
                case (.error(_), _), (_, .error(_)):
                    return nil

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

        liveSessionService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] liveEventService in

                guard
                    let self,
                    case .results(var cells, let indexFirstToAppear) = self.state,
                    let index = cells.firstIndex(where: { $0.id == .live }),
                    case .live(let timeInterval, let sessionName) = self.events[index].status
                else {
                    return nil
                }

                let sessionListViewModel = SessionListViewModel.make(event: events[index], navigation: navigation)

                switch liveEventService {
                case .refreshed(let liveSession):

                    let positions = liveSession.standings
                    guard !positions.isEmpty else {

                        self.eventService.action.send(.updateAll)
                        return nil
                    }

                    let podium: [Driver.ID] = positions.map { $0.driverId }

                    cells[index] = .live(
                        self.buildLiveViewModel(
                            event: self.events[index],
                            timeInterval: timeInterval,
                            sessionName: sessionName,
                            podium: Driver.getPodiumDriverTickers(podium: podium, drivers: drivers),
                            sessionListViewModel: sessionListViewModel
                        )
                    )

                    return .results(cells: cells, indexFirstToAppear: indexFirstToAppear)

                case .refreshing, .error:

                    cells[index] = .live(
                        self.buildLiveViewModel(
                            event: self.events[index],
                            timeInterval: timeInterval,
                            sessionName: sessionName,
                            podium: [],
                            sessionListViewModel: sessionListViewModel
                        )
                    )

                    return .results(cells: cells, indexFirstToAppear: indexFirstToAppear)
                }
            }
            .assign(to: &$state)
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }

                switch action {
                case .resumeTimers:
                    liveSessionService.action.send(.fetchPositions)
                    _ = buildAllEventCells()
                case .stopTimers:
                    self.liveEventTimer?.invalidate()
                case .tap, .verifyPremium:
                    return
                }
            }
            .store(in: &subscriptions)
    }

    private func updateLiveEventTimer(timeInterval: TimeInterval, triggerInterval: Double) {

        liveEventTimer?.invalidate()

        liveEventTimer =
        Timer.scheduledTimer(withTimeInterval: triggerInterval, repeats: true) { [weak self, timeInterval] _ in

            guard let self else { return }

            if timeInterval < .minuteInterval {

                self.liveSessionService.action.send(.updatePositions)
            } else {

                guard
                    case .results(var cells, let indexFirstToAppear) = self.state,
                    let index = cells.firstIndex(where: { $0.id == .live }),
                    case .live(let timeInterval, let sessionName) = events[index].status
                else {
                    return
                }

                let sessionListViewModel = SessionListViewModel.make(event: events[index], navigation: navigation)

                cells[index] = .live(
                    buildLiveViewModel(
                        event: events[index],
                        timeInterval: timeInterval,
                        sessionName: sessionName,
                        podium: [],
                        sessionListViewModel: sessionListViewModel
                    )
                )

                state = .results(cells: cells, indexFirstToAppear: indexFirstToAppear)
            }
        }
    }

    private func buildAllEventCells() -> State {

        eventCells = events.compactMap { event in

            let sessionListViewModel = SessionListViewModel.make(event: event, navigation: navigation)

            switch event.status {
            case .live(let timeInterval, let sessionName):

                updateLiveEventTimer(timeInterval: timeInterval, triggerInterval: 15)

                return .live(
                    buildLiveViewModel(
                        event: event,
                        timeInterval: timeInterval,
                        sessionName: sessionName,
                        podium: [],
                        sessionListViewModel: sessionListViewModel
                    )
                )
            case .upcoming(let start, let end, let sessionName, let timeInterval):

                if let timeInterval, timeInterval > .liveInSeconds {
                    updateLiveEventTimer(timeInterval: timeInterval, triggerInterval: .minuteInterval)
                }

                return .upcoming(
                    buildUpcomingViewModel(
                        event: event,
                        start: start,
                        end: end,
                        sessionName: sessionName,
                        timeInterval: timeInterval,
                        sessionListViewModel: sessionListViewModel
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
                        podium: tickers,
                        sessionListViewModel: sessionListViewModel
                    )
                )
            case .calledOff:

                return .calledOff(buildCalledOffCardViewModel(event: event))
            }
        }

        for (index, cell) in eventCells.enumerated() {
            switch cell {
            case .live, .upcoming:
                return .results(cells: eventCells, indexFirstToAppear: index)
            case .finished, .calledOff:
                continue
            }
        }

        return .results(cells: eventCells, indexFirstToAppear: 0)
    }

    private func buildLiveViewModel(
        event: Event,
        timeInterval: TimeInterval,
        sessionName: String,
        podium: [String],
        sessionListViewModel: SessionListViewModel
    ) -> LiveEventCardViewModel {
        
        let viewModel: LiveEventCardViewModel = .init(
            id: event.id,
            title: event.title,
            country: event.country,
            round: event.round,
            timeInterval: timeInterval,
            sessionName: sessionName,
            podium: podium,
            state: setUpLiveEventState(podium: podium, timeInterval: timeInterval)
        )
        
        viewModel.action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .tapEvent:
                    navigation.action.send(.append(route: .sessionsList(sessionListViewModel)))
                }
            }
            .store(in: &subscriptions)
        
        return viewModel
    }

    private func buildUpcomingViewModel(
        event: Event,
        start: String,
        end: String,
        sessionName: String,
        timeInterval: TimeInterval?,
        sessionListViewModel: SessionListViewModel
    ) -> UpcomingEventCardViewModel {
        
        let viewModel: UpcomingEventCardViewModel = .init(
            id: event.id,
            title: event.title,
            country: event.country,
            round: event.round,
            start: start,
            end: end,
            sessionName: sessionName,
            timeInterval: timeInterval
        )
        
        viewModel.action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .tapEvent:
                    navigation.action.send(.append(route: .sessionsList(sessionListViewModel)))
                }
            }
            .store(in: &subscriptions)

        return viewModel
    }

    private func buildFinishedCardViewModel(
        event: Event,
        podium: [String],
        sessionListViewModel: SessionListViewModel
    ) -> FinishedEventCardViewModel {
        
        let viewModel: FinishedEventCardViewModel = .init(
            id: event.id,
            title: event.title,
            country: event.country,
            round: event.round,
            podium: podium
        )
        
        viewModel.action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .tapEvent:
                    navigation.action.send(.append(route: .sessionsList(sessionListViewModel)))
                }
            }
            .store(in: &subscriptions)
        
        return viewModel
    }

    private func buildCalledOffCardViewModel(event: Event) -> CalledOffEventCardViewModel {

        CalledOffEventCardViewModel(title: event.title, country: event.country, round: event.round)
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
        case calledOff(CalledOffEventCardViewModel)

        var id: Identifier {

            switch self {
            case .live: return .live
            case .upcoming(let viewModel): return .upcoming(viewModel.id.string)
            case .finished(let viewModel): return .finished(viewModel.id.string)
            case .calledOff: return .calledOff
            }
        }

        enum Identifier: Hashable {

            case live
            case upcoming(String)
            case finished(String)
            case calledOff
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

        case resumeTimers
        case stopTimers
        case verifyPremium
        case tap(index: Int)
    }

    enum State: Equatable {

        case results(cells: [Cell], indexFirstToAppear: Int)
        case loading

        enum Identifier: String {

            case loading
            case results
        }

        var id: Identifier {

            switch self {
            case .loading: return .loading
            case .results: return .results
            }
        }

        static func == (
            lhs: Self,
            rhs: Self
        ) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension SeasonListViewModel {

    static func make(navigation: AppNavigationRepresentable) -> SeasonListViewModel {

        .init(
            navigation: navigation,
            driversAndConstructorService: ServiceLocator.shared.driverAndConstructorService,
            eventService: ServiceLocator.shared.eventService,
            liveEventService: ServiceLocator.shared.liveSessionService,
            purchaseService: ServiceLocator.shared.purchaseService
        )
    }
}
