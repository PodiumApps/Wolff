import Foundation

protocol LiveEventCardViewModelRepresentable {

    var id: Event.ID { get }
    var title: String { get }
    var country: String { get }
    var round: Int { get }
    var timeInterval: TimeInterval { get }
    var sessionName: String { get }
    var podium: [String]? { get }
    var state: LiveEventCardViewModel.State { get }
}

final class LiveEventCardViewModel: LiveEventCardViewModelRepresentable {

    var id: Event.ID
    var title: String
    var country: String
    var round: Int
    var timeInterval: TimeInterval
    var sessionName: String
    var podium: [String]?

    var state: State { setUpLiveEventState() }

    init(
        id: Event.ID,
        title: String,
        country: String,
        round: Int,
        timeInterval: TimeInterval,
        sessionName: String,
        podium: [String]? = nil
    ) {

        self.id = id
        self.title = title
        self.country = country
        self.round = round
        self.timeInterval = timeInterval
        self.sessionName = sessionName
        self.podium = podium
    }
}

extension LiveEventCardViewModel {

    enum State {

        case betweenOneMinuteAndFourHoursToGo(hours: Int, minutes: Int)
        case aboutToStart // Less than one minute
        case happeningNow(podium: [String])
    }

    private func setUpLiveEventState() -> State {

        guard let podium else {

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
