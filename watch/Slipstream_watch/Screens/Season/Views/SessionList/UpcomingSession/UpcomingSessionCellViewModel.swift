import Foundation

protocol UpcomingSessionCellViewModelRepresentable {

    var sessionName: String { get }
    var date: Date { get }
    var formattedDate: String { get }
}

final class UpcomingSessionCellViewModel: UpcomingSessionCellViewModelRepresentable {

    var sessionName: String
    var date: Date
    var formattedDate: String

    init(sessionName: String, date: Date) {

        self.sessionName = sessionName
        self.date = date

        if self.date.isSessionToday {

            self.formattedDate = Localization.SessionTime.today(DateFormatter.timeForSession.string(from: self.date))
        } else if self.date.isSessionTomorrow {

            self.formattedDate = Localization.SessionTime.tomorrow(DateFormatter.timeForSession.string(from: self.date))
        } else {
            
            self.formattedDate = DateFormatter.session.string(from: self.date)
        }
    }
}
