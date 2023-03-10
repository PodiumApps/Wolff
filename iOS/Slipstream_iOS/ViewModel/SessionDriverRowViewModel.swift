import Foundation
import SwiftUI

protocol SessionDriverRowViewModelRepresentable: ObservableObject {

    var position: Int { get }
    var driverTicker: String { get }
    var timeGap: String? { get }
    var tyrePitCount: Int { get }
    var currentTyre: LivePosition.Tyre { get }
    var constructorId: Constructor.ID { get }

    var isSelected: Bool { get set }

    func toggleSelection() -> Void
}

final class SessionDriverRowViewModel: SessionDriverRowViewModelRepresentable {

    let position: Int
    let driverTicker: String
    let timeGap: String?
    let tyrePitCount: Int
    let currentTyre: LivePosition.Tyre
    let constructorId: Constructor.ID

    @Published var isSelected: Bool

    init(
        position: Int,
        driverTicker: String,
        timeGap: String?,
        tyrePitCount: Int,
        currentTyre: LivePosition.Tyre,
        constructorId: Constructor.ID,
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

extension SessionDriverRowViewModel {
    
    static var mockArray: [SessionDriverRowViewModel] = [
        .init(
            position: 1,
            driverTicker: "VER",
            timeGap: "Leader",
            tyrePitCount: 2,
            currentTyre: .hard,
            constructorId: .init("red_bull_rgbpt")
        ),
        .init(
            position: 1,
            driverTicker: "VER",
            timeGap: "Leader",
            tyrePitCount: 2,
            currentTyre: .medium,
            constructorId: .init("red_bull_rgbpt")
        ),
        .init(
            position: 2,
            driverTicker: "HAM",
            timeGap: "Leader",
            tyrePitCount: 2,
            currentTyre: .soft,
            constructorId: .init("mercedes")
        ),
        .init(
            position: 2,
            driverTicker: "HAM",
            timeGap: "Leader",
            tyrePitCount: 2,
            currentTyre: .soft,
            constructorId: .init("mercedes")
        ),
        .init(
            position: 3,
            driverTicker: "LEC",
            timeGap: "Leader",
            tyrePitCount: 2,
            currentTyre: .hard,
            constructorId: .init("ferrari")
        ),
        .init(
            position: 3,
            driverTicker: "LEC",
            timeGap: "Leader",
            tyrePitCount: 2,
            currentTyre: .soft,
            constructorId: .init("ferrari")
        ),
        .init(
            position: 4,
            driverTicker: "PER",
            timeGap: "Leader",
            tyrePitCount: 2,
            currentTyre: .medium,
            constructorId: .init("haas")
        ),
        .init(
            position: 4,
            driverTicker: "PER",
            timeGap: "Leader",
            tyrePitCount: 2,
            currentTyre: .soft,
            constructorId: .init("haas")
        ),
        .init(
            position: 5,
            driverTicker: "VER",
            timeGap: "Leader",
            tyrePitCount: 2,
            currentTyre: .hard,
            constructorId: .init("alphaTauri")
        ),
        .init(
            position: 5,
            driverTicker: "VER",
            timeGap: "Leader",
            tyrePitCount: 2,
            currentTyre: .soft,
            constructorId: .init("alphaTauri")
        )
    ]
}
