import Foundation

protocol ScheduleCarouselViewModelRepresentable {

    var round: Int { get }
    var title: String { get }
    var eventStatus: Event.Status { get }
}

final class ScheduleCarouselViewModel: ScheduleCarouselViewModelRepresentable {

    var round: Int
    var title: String
    var eventStatus: Event.Status

    init(round: Int, title: String, eventStatus: Event.Status) {

        self.round = round
        self.title = title.uppercased()
        self.eventStatus = eventStatus
    }
}

extension ScheduleCarouselViewModel {
    
    static let mockUpcoming: ScheduleCarouselViewModel = .init(
        round: 13,
        title: "Emilia Romagna 2023",
        eventStatus: .upcoming(start: "05", end: "07 MAY", session: nil)
    )
    
    static let mockLive: ScheduleCarouselViewModel = .init(
        round: 13,
        title: "Emilia Romagna 2023",
        eventStatus: .live(timeToEvent: "2h30min", session: .race, drivers: [])
    )
    
    static let mockLiveEvent: ScheduleCarouselViewModel = .init(
        round: 13,
        title: "Emilia Romagna 2023",
        eventStatus: .live(
            timeToEvent: "",
            session: .race,
            drivers: [
                .init(driverTicker: Driver.mockVertasppen.driverTicker, value: .first),
                .init(driverTicker: Driver.mockHamilton.driverTicker, value: .second),
                .init(driverTicker: Driver.mockAlonso.driverTicker, value: .third)
            ]
        )
    )
    
    static let mockFinished: ScheduleCarouselViewModel = .init(
        round: 13,
        title: "Emilia Romagna 2023",
        eventStatus: .finished(winner: Driver.mockHamilton.driverTicker)
    )
}
