import Foundation
import SwiftUI

protocol SessionDriverRowViewModelRepresentable: ObservableObject {

    var position: Int { get }
    var driverTicker: String { get }
    var timeGap: String? { get }
    var tyrePitCount: Int { get }
    var currentTyre: LivePosition.Tyre { get }

    var isSelected: Bool { get set }

    func toggleSelection() -> Void
}

final class SessionDriverRowViewModel: SessionDriverRowViewModelRepresentable {

    var position: Int
    var driverTicker: String
    var timeGap: String?
    var tyrePitCount: Int
    var currentTyre: LivePosition.Tyre

    @Published var isSelected: Bool

    init(
        position: Int,
        driverTicker: String,
        timeGap: String?,
        tyrePitCount: Int,
        currentTyre: LivePosition.Tyre,
        isSelected: Bool = false
    ) {

        self.position = position
        self.driverTicker = driverTicker
        self.timeGap = timeGap
        self.tyrePitCount = tyrePitCount
        self.currentTyre = currentTyre

        self.isSelected = isSelected
    }

    func toggleSelection() {

        isSelected = !isSelected
    }
}
