import Foundation

protocol GrandPrixCardViewModelRepresentable {
    
    var round: Int { get }
    var title: String { get }
    var subtitle: String { get }
    var grandPrixDate: String { get }
    var isNext: Bool { get }
}

final class GrandPrixCardViewModel: GrandPrixCardViewModelRepresentable {

    let round: Int
    let title: String
    let subtitle: String
    let grandPrixDate: String
    let isNext: Bool

    init(
        round: Int,
        title: String,
        subtitle: String,
        grandPrixDate: String,
        isNext: Bool = false
    ) {

        self.round = round
        self.title = title
        self.subtitle = subtitle
        self.grandPrixDate = grandPrixDate.capitalized
        self.isNext = isNext
    }
}

extension GrandPrixCardViewModel {
    
    static let mockShortDate: GrandPrixCardViewModel = .init(
        round: 13,
        title: "Emilia Romagna",
        subtitle: "Italy",
        grandPrixDate: "21 - 23 October"
    )
    
    static let mockFullDate: GrandPrixCardViewModel = .init(
        round: 13,
        title: "Spa-Francorchamps",
        subtitle: "Belgium",
        grandPrixDate: "21 October - 23 October"
    )
    
    static let mockNextFullDate: GrandPrixCardViewModel = .init(
        round: 13,
        title: "Spa-Francorchamps",
        subtitle: "Belgium",
        grandPrixDate: "21 - 23 October",
        isNext: true
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
