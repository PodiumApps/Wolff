import SwiftUI

struct GrandPrixCardView<ViewModel: GrandPrixCardRepresentable>: View {

    @State private var liveCircleAnimationAmount = Constants.liveCircleAnimationAmount

    private let viewModel: ViewModel
    private var eventStatusBackgroundStyler: EventStatusBackgroundStyler

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
        self.eventStatusBackgroundStyler = EventStatusBackgroundStyler(eventStatus: viewModel.eventStatus)
    }

    var body: some View {

        HStack {
            VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
                HStack(alignment: .firstTextBaseline) {
                    Text(viewModel.title.uppercased())
                        .minimumScaleFactor(Constants.eventTitleTextScalingFactor)
                        .font(.eventTitleFont)
                    Text("Round \(viewModel.round)")
                        .font(.eventRoundNumberFont)

                    Spacer()
                }

                switch viewModel.eventStatus {
                case .finished:
                    if let drivers = viewModel.drivers {
                        driversPositionComponent(drivers: drivers)
                    }
                case .live, .current:
                    if let title = viewModel.currentSessionTitle, let details = viewModel.currentSessionDetails {
                        sessionDetailsComponent(title: title, details: details)
                    }
                case .upcoming:
                    if let details = viewModel.currentSessionDetails {
                        sessionDetailsComponent(details: details)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(Constants.cardContentPadding)

            Spacer()

            switch viewModel.eventStatus {
            case .finished, .upcoming, .current:
                Image.chevronRight
                    .font(.chevronRightFont)
                    .padding(.trailing, Constants.cardContentPadding)
            case .live:
                liveIndicatorComponent()
            }
        }
        .frame(width: Constants.cardWidth, height: Constants.cardHeigth)
        .background(eventStatusBackgroundStyler.color)
        .clipShape(
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
        )
        .shadow(
            radius: Constants.cardShadowRadius,
            x: Constants.cardHorizontalShadow,
            y: Constants.cardVerticalShadow
        )
    }

    func driversPositionComponent(drivers: [DriverResult]) -> some View {

        HStack(spacing: Constants.horizontalSpacing) {
            ForEach(drivers) {
                driverLabel(position: $0.value, driverTicker: $0.id)
            }
        }
    }

    func driverLabel(position: DriverResult.Value, driverTicker: String) -> some View {

        HStack(spacing: Constants.horizontalDriversComponentSpacing) {
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

    func sessionDetailsComponent(title: String? = .none, details: String) -> some View {

        HStack {
            if let title = title {
                Text(title)
                    .font(.liveSessionTitleFont)
            }

            if viewModel.eventStatus == .live || viewModel.eventStatus == .upcoming {
                Text(details)
            } else {
                Text("\(details) until start")
            }
        }
    }

    func liveIndicatorComponent() -> some View {

        HStack {
            Circle()
                .frame(width: Constants.liveCircleSize)
                .scaleEffect(liveCircleAnimationAmount)
                .animation(
                    .easeInOut(
                        duration: Constants.liveCircleAnimationDuration).repeatForever(autoreverses: true),
                        value: liveCircleAnimationAmount
                    )
                .onAppear {
                    liveCircleAnimationAmount -= Constants.liveCircleAnimationDecrease
                }

            Text("LIVE")
                .font(.liveTextFont)
        }
        .frame(maxWidth: Constants.liveComponentWidth, maxHeight: .infinity)
        .foregroundColor(.white)
        .background(Color.red)
    }

    func applyForegroundColor(position: DriverResult.Value) -> Color {

        switch position {
        case .first: return Color.yellow
        case .second: return Color.gray
        case .third: return Color.brown
        }
    }
}

fileprivate enum Constants {

    static let cardWidth: CGFloat = UIScreen.main.bounds.width * 0.95
    static let cardHeigth: CGFloat = 70
    static let cardCornerRadius: CGFloat = 10
    static let cardContentPadding: CGFloat = 12
    static let cardHorizontalShadow: CGFloat = 7
    static let cardVerticalShadow: CGFloat = 7
    static let cardShadowRadius: CGFloat = 7

    static let eventTitleTextScalingFactor: CGFloat = 0.75

    static let verticalSpacing: CGFloat = 7
    static let horizontalSpacing: CGFloat = 14

    static let horizontalDriversComponentSpacing: CGFloat = 7

    static let liveComponentWidth: CGFloat = 80
    static let liveCircleSize: CGFloat = 12
    static let liveCircleAnimationDuration: Double = 1
    static let liveCircleAnimationAmount: Double = 1
    static let liveCircleAnimationDecrease: Double = 0.6
}

struct ScheduleCarouselComponentView_Previews: PreviewProvider {
    static var previews: some View {

        GrandPrixCardView(
            viewModel:
                GrandPrixCardViewModel(
                    round: 13,
                    title: "Emilia Romagna 2023",
                    circuitID: "bahrain_2023",
                    eventSatus: .upcoming,
                    currentSessionTitle: "FP1",
                    currentSessionDetails: "05-07 MAY",
                    drivers: [
                        .init(id: "HAM", value: .first),
                        .init(id: "LEC", value: .second),
                        .init(id: "VER", value: .third)
                    ]
                )
        )

        GrandPrixCardView(
            viewModel:
                GrandPrixCardViewModel(
                    round: 13,
                    title: "Emilia Romagna 2023",
                    circuitID: "bahrain_2023",
                    eventSatus: .current,
                    currentSessionTitle: "FP1",
                    currentSessionDetails: "10:30h",
                    drivers: [
                        .init(id: "HAM", value: .first),
                        .init(id: "LEC", value: .second),
                        .init(id: "VER", value: .third)
                    ]
                )
        )

        GrandPrixCardView(
            viewModel:
                GrandPrixCardViewModel(
                    round: 3,
                    title: "Emilia Romagna 2023",
                    circuitID: "bahrain_2023",
                    eventSatus: .live,
                    currentSessionTitle: "Race",
                    currentSessionDetails: "Lap 22 of 52",
                    drivers: [
                        .init(id: "HAM", value: .first),
                        .init(id: "LEC", value: .second),
                        .init(id: "VER", value: .third)
                    ]
                )
        )

        GrandPrixCardView(
            viewModel:
                GrandPrixCardViewModel(
                    round: 3,
                    title: "Bahrain 2023",
                    circuitID: "bahrain_2023",
                    eventSatus: .finished,
                    drivers: [
                        .init(id: "HAM", value: .first),
                        .init(id: "LEC", value: .second),
                        .init(id: "VER", value: .third)
                    ]
                )
        )
    }
}
