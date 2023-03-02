import Foundation
import SwiftUI

protocol SessionDriverRowViewModelRepresentable: ObservableObject {

    var position: Int { get }
    var driverTicker: String { get }
    var timeGap: String? { get }
    var tyrePitCount: Int { get }
    var currentTyre: SessionDriverRowViewModel.Tyre { get }

    var isSelected: Bool { get set }

    func toggleSelection() -> Void
}

final class SessionDriverRowViewModel: SessionDriverRowViewModelRepresentable {

    var position: Int
    var driverTicker: String
    var timeGap: String?
    var tyrePitCount: Int
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
            case .soft: return .Tyre.soft
            case .medium: return .Tyre.medium
            case .hard: return .Tyre.hard
            case .intermediate: return .Tyre.intermediate
            case .wet: return .Tyre.wet
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
        self.currentTyre = LivePosition.Tyre.getTyreStyle(for: currentTyre)

        self.isSelected = isSelected
    }

    func toggleSelection() {

        isSelected = !isSelected
    }
}
