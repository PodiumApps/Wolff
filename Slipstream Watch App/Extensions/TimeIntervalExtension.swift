import Foundation

extension TimeInterval {

    var hoursAndMinutes: (hours: Int, minutes: Int) {

        let hours = Int(self) / (60 * 60)
        let minutes = Int(self) % (60 * 60) / 60

        return (hours, minutes)
    }
}
