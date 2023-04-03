import Foundation
import Combine

protocol SessionListViewModelRepresentable {

    var state: SessionListViewModel.State { get }
}

final class SessionListViewModel: SessionListViewModelRepresentable {

    private let event: Event
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let liveSessionService: LiveSessionServiceRepresentable

    private var timer: Timer?

    @Published var state: State
    @Published private var sessionCells: [Cell]

    init(
        event: Event,
        driverAndConstructorService: DriverAndConstructorServiceRepresentable,
        liveSessionService: LiveSessionServiceRepresentable
    ) {

        self.event = event
        self.driverAndConstructorService = driverAndConstructorService
        self.liveSessionService = liveSessionService

        self.state = .loading
        self.sessionCells = []
    }

    private func buildSessionRows() -> State {

        sessionCells = event.sessions.compactMap { session in

            if session.winners.isEmpty {
                return .upcoming(
                    buildUpcomingSessionCellViewModel(
                        sessionName: session.name,
                        date: session.date
                    )
                )
            } else {
                return .finished(
                    buildFinishedSessionCellViewModel(
                        sessionName: session.name,
                        winners: session.winners
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

//    private func buildLiveSessionCellViewModel() -> LiveSessionCellViewModel {
//
//    }

    private func buildFinishedSessionCellViewModel(sessionName: Session.Name, winners: [Driver.ID]) -> FinishedSessionCellViewModel {

        return FinishedSessionCellViewModel(
            session: sessionName.label,
            winners: []
        )
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
//        case live(LiveSessionCellViewModel)
        case finished(FinishedSessionCellViewModel)

        enum Identifier {

            case upcoming
//            case live
            case finished
        }

        var id: Identifier {

            switch self {
            case .upcoming: return .upcoming
//            case .live: return .live
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
