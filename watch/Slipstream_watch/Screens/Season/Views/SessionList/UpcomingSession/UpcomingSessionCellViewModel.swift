import Foundation

protocol UpcomingSessionCellViewModelRepresentable {

    var sessionName: String { get }
    var formattedDate: String { get }
}

final class UpcomingSessionCellViewModel: UpcomingSessionCellViewModelRepresentable {

    var sessionName: String
    var formattedDate: String

    init(sessionName: String, date: Date) {

        self.sessionName = sessionName

        if date.isSessionToday {

            self.formattedDate = Localization.SessionTime.today(DateFormatter.timeForSession.string(from: date))
        } else if date.isSessionTomorrow {

            self.formattedDate = Localization.SessionTime.tomorrow(DateFormatter.timeForSession.string(from: date))
        } else {

            self.formattedDate = DateFormatter.session.string(from: date)
        }
    }
}
