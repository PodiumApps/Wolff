import SwiftUI

struct EventComponentView: View {

    var eventStatus: Event.Status

    var body: some View {

        switch eventStatus {
        case .current(let title, let details), .live(title: let title, details: let details):
            sessionDetailsComponent(title: title, details: details)
        case .finished(drivers: let drivers):
            driversPositionComponent(drivers: drivers)
        case .upcoming(details: let details):
            sessionDetailsComponent(details: details)
        }
    }

    func driversPositionComponent(drivers: [DriverResult]) -> some View {

        HStack(spacing: Constants.DriverComponent.horizontalSpacing) {
            ForEach(drivers) {
                driverLabel(position: $0.value, driverTicker: $0.driverTicker)
            }
        }
    }

    func driverLabel(position: DriverResult.Value, driverTicker: String) -> some View {

        HStack(spacing: Constants.DriverComponent.horizontalDriversComponentSpacing) {
            if position == .first {
                Image.trophyIcon
            } else {
                Text(position.label)
            }

            Text(driverTicker)
        }
        .foregroundColor(applyForegroundColor(position: position))
        .bold()
    }

    func sessionDetailsComponent(title: String? = nil, details: String) -> some View {

        HStack {
            if let title = title {
                Text(title)
                    .font(.liveSessionTitleFont)
            }

            Text(details)
        }
    }

    func applyForegroundColor(position: DriverResult.Value) -> Color {

        switch position {
        case .first: return .yellow
        case .second: return .gray
        case .third: return .brown
        }
    }
}

fileprivate enum Constants {

    enum DriverComponent {

        static let horizontalSpacing: CGFloat = 14
        static let horizontalDriversComponentSpacing: CGFloat = 7
    }
}
