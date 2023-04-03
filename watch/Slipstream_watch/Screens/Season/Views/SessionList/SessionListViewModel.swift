import Foundation
import Combine

protocol SessionListViewModelRepresentable {

    var state: SessionListViewModel.State { get }
}

final class SessionListViewModel: SessionListViewModelRepresentable {

    private let event: Event

    @Published var state: State
    @Published private var sessionCells: [Cell]

    init(event: Event) {

        self.event = event

        self.state = .loading
        self.sessionCells = []

        self.state = buildSessionRows()
    }

    private func buildSessionRows() -> State {

        var liveEventCellBuilt = false

        sessionCells = event.sessions.compactMap { session in

            if case .live = event.status {
                if session.winners.isEmpty && !liveEventCellBuilt {
                    liveEventCellBuilt = true
                    return .live(
                        buildLiveSessionCellViewModel(sessionName: session.name, podium: [])
                    )
                } else {
                    if session.winners.isEmpty {
                        return .upcoming(
                            buildUpcomingSessionCellViewModel(
                                sessionName: session.name, date: session.date
                            )
                        )
                    } else {
                        return .finished(
                            buildFinishedSessionCellViewModel(
                                sessionName: session.name, winners: session.winners
                            )
                        )
                    }
                }
            } else {
                if session.winners.isEmpty {
                    return .upcoming(
                        buildUpcomingSessionCellViewModel(
                            sessionName: session.name, date: session.date
                        )
                    )
                } else {
                    return .finished(
                        buildFinishedSessionCellViewModel(
                            sessionName: session.name, winners: session.winners
                        )
                    )
                }
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

    private func buildLiveSessionCellViewModel(sessionName: Session.Name, podium: [Driver.ID]) -> LiveSessionCellViewModel {

        return LiveSessionCellViewModel(
            sessionName: sessionName.label,
            podium: ["VER", "HAM", "ALO"]
        )
    }

    private func buildFinishedSessionCellViewModel(sessionName: Session.Name, winners: [Driver.ID]) -> FinishedSessionCellViewModel {

        return FinishedSessionCellViewModel(
            session: sessionName.label,
            winners: ["HAM", "ALO", "VER"]
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
