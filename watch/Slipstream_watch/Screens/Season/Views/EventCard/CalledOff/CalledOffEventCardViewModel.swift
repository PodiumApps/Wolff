import Foundation

protocol CalledOffEventCardViewModelRepresentable: ObservableObject {

    var title: String { get }
    var country: String { get }
    var round: Int { get }
}

final class CalledOffEventCardViewModel: CalledOffEventCardViewModelRepresentable {

    let title: String
    let country: String
    let round: Int

    init(title: String, country: String, round: Int) {

        self.title = title
        self.country = country
        self.round = round
    }
}
