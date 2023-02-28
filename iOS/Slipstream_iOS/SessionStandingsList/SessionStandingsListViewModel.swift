import Foundation

protocol SessionStandingsListViewModelRepresentable: ObservableObject {

    var standings: [SessionDriverRowViewModel] { get set }

    func tapRow(at index: Int) -> Void
}

final class SessionStandingsListViewModel: SessionStandingsListViewModelRepresentable {

    @Published var standings: [SessionDriverRowViewModel]

    init(standings: [SessionDriverRowViewModel]) {
        self.standings = standings

        if !standings.isEmpty {
            standings[0].isSelected = true
        }
    }

    func tapRow(at index: Int) {

        for i in 0 ..< standings.count {
            if standings[i].isSelected {
                standings[i].toggleSelection()
            }
        }

        standings[index].toggleSelection()
    }
}
