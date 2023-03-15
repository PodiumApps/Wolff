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
        eventStatus: .live(timeInterval: .init(400), sessionName: "Race", driverTickers: [])
    )
    
    static let mockLiveEvent: ScheduleCarouselViewModel = .init(
        round: 13,
        title: "Emilia Romagna 2023",
        eventStatus: .live(
            timeInterval: .init(0),
            sessionName: "Race",
            driverTickers: [
                Driver.mockVertasppen.driverTicker,
                Driver.mockHamilton.driverTicker,
                Driver.mockAlonso.driverTicker
            ]
        )
    )
    
    static let mockFinished: ScheduleCarouselViewModel = .init(
        round: 13,
        title: "Emilia Romagna 2023",
        eventStatus: .finished(winner: Driver.mockHamilton.driverTicker)
    )
}
