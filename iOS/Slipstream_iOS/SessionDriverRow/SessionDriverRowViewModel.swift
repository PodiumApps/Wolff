import Foundation
import SwiftUI

protocol SessionDriverRowViewModelRepresentable: ObservableObject {

    var position: Int { get }
    var driverTicker: String { get }
    var timeGap: String? { get }
    var tyrePitCount: Int { get }
    var currentTyre: LivePosition.Tyre { get }
    var constructorId: String { get }

    var isSelected: Bool { get set }

    func toggleSelection() -> Void
}

final class SessionDriverRowViewModel: SessionDriverRowViewModelRepresentable {

    let position: Int
    let driverTicker: String
    let timeGap: String?
    let tyrePitCount: Int
    let currentTyre: LivePosition.Tyre
    let constructorId: String

    @Published var isSelected: Bool

    init(
        position: Int,
        driverTicker: String,
        timeGap: String?,
        tyrePitCount: Int,
        currentTyre: LivePosition.Tyre,
        constructorId: String,
        isSelected: Bool = false
    ) {

        self.position = position
        self.driverTicker = driverTicker
        self.timeGap = timeGap
        self.tyrePitCount = tyrePitCount
        self.currentTyre = currentTyre
        self.constructorId = constructorId

        self.isSelected = isSelected
    }

    func toggleSelection() {

        isSelected = !isSelected
    }
}
