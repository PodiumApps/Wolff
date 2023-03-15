import SwiftUI

struct EventComponentView: View {

    var eventStatus: Event.Status

    var body: some View {

        switch eventStatus {
        case .live(let timeToEvent, let session, let drivers):
            if drivers.isEmpty {
                sessionDetailsComponent(title: "\(timeToEvent)", details: session)
            } else {
                Text("Something here")
//                driversPositionComponent(for: drivers)
            }
        case .finished(let driver):
            Text(driver)
        case .upcoming(let start, let end, let session, _):
            sessionDetailsComponent(title: start + "-" + end, details: "\(session)")
        }
    }
    
    func driversPositionComponent(for drivers: [DriverResult]) -> some View {
        
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
