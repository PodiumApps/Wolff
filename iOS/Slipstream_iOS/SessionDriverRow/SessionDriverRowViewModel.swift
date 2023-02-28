import Foundation
import SwiftUI

protocol SessionDriverRowViewModelRepresentable: ObservableObject {

    var position: String { get }
    var driverTicker: String { get }
    var timeGap: String { get }
    var tyrePitCount: String { get }
    var currentTyre: SessionDriverRowViewModel.Tyre { get }

    var isSelected: Bool { get set }

    func toggleSelection() -> Void
}

final class SessionDriverRowViewModel: SessionDriverRowViewModelRepresentable {

    var position: String
    var driverTicker: String
    var timeGap: String
    var tyrePitCount: String
    var currentTyre: Tyre

    @Published var isSelected: Bool

    enum Tyre {
        case soft
        case medium
        case hard
        case intermediate
        case wet

        var color: Color {
            switch self {
            case .soft: return Color.Tyre.soft
            case .medium: return Color.Tyre.medium
            case .hard: return Color.Tyre.hard
            case .intermediate: return Color.Tyre.intermediate
            case .wet: return Color.Tyre.wet
            }
        }

        var name: String {
            switch self {
            case .soft: return "Soft"
            case .medium: return "Medium"
            case .hard: return "Hard"
            case .intermediate: return "Inter"
            case .wet: return "Wet"
            }
        }
    }

    init(
        position: String,
        driverTicker: String,
        timeGap: String,
        tyrePitCount: String,
        currentTyre: LivePosition.Tyre,
        isSelected: Bool = false
    ) {

        self.position = position
        self.driverTicker = driverTicker
        self.timeGap = timeGap
        self.tyrePitCount = tyrePitCount
        self.currentTyre = LivePosition.Tyre.getTyreStyle(for: currentTyre)

        self.isSelected = isSelected
    }

    func toggleSelection() {

        isSelected = !isSelected
    }
}
