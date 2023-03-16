import Foundation

protocol GrandPrixCardViewModelRepresentable {
    
    var round: Int { get }
    var title: String { get }
    var subtitle: String { get }
    var grandPrixDate: String { get }
    var winners: [String] { get }
    var nextSession: String? { get }
}

final class GrandPrixCardViewModel: GrandPrixCardViewModelRepresentable {

    let round: Int
    let title: String
    let subtitle: String
    let grandPrixDate: String
    let winners: [String]
    let nextSession: String?

    init(
        round: Int,
        title: String,
        subtitle: String,
        grandPrixDate: String,
        winners: [String],
        nextSession: TimeInterval? = nil
    ) {

        self.round = round
        self.title = title
        self.subtitle = subtitle
        self.winners = winners
        self.grandPrixDate = grandPrixDate.capitalized
        
        let weekInterval: Double = 7*24*60*60
        let dayInterval: Double = 24*60*60
        
        if let nextSession = nextSession, nextSession < weekInterval {
            let formatter = DateComponentsFormatter()
            
            formatter.allowedUnits = nextSession < dayInterval ? [.hour, .minute] : [.day, .hour]
            formatter.calendar?.locale = Locale(identifier: "en_us")
            formatter.zeroFormattingBehavior = .pad
            
            let string = formatter.string(from: nextSession) ?? "0:00"
            let finalString = nextSession < dayInterval
                ? string.replacingOccurrences(of: ":", with: "h ") + "min"
                : string.uppercased()
            
            self.nextSession = finalString
        } else {
            self.nextSession = nil
            
        }
    }
}

extension GrandPrixCardViewModel {
    
    static let mockShortDate: GrandPrixCardViewModel = .init(
        round: 13,
        title: "Emilia Romagna",
        subtitle: "Italy",
        grandPrixDate: "21 - 23 October",
        winners: []
    )
    
    static let mockFullDate: GrandPrixCardViewModel = .init(
        round: 13,
        title: "Spa-Francorchamps",
        subtitle: "Belgium",
        grandPrixDate: "21 October - 23 October",
        winners: []
    )
    
    static let mockNextFullDate: GrandPrixCardViewModel = .init(
        round: 13,
        title: "Spa-Francorchamps",
        subtitle: "Belgium",
        grandPrixDate: "21 - 23 October",
        winners: [],
        nextSession: .init(320000)
    )
    
    static let mockArray: [GrandPrixCardViewModel] = [
        .mockShortDate,
        .mockFullDate,
        .mockShortDate,
        .mockFullDate,
        .mockShortDate,
        .mockShortDate,
        .mockShortDate,
        .mockFullDate,
        .mockFullDate,
        .mockFullDate,
        .mockShortDate
    ]
}
