import SwiftUI

struct GrandPrixCardView<ViewModel: GrandPrixCardViewModelRepresentable>: View {

    @State private var liveCircleAnimationAmount = Constants.LiveComponent.circleAnimationAmount

    private let viewModel: ViewModel
    private var eventStatusBackgroundStyler: EventStatusBackgroundStyler

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
        self.eventStatusBackgroundStyler = EventStatusBackgroundStyler(grandPrixCardStatus: viewModel.eventStatus)
    }

    var body: some View {

        HStack {
            VStack(alignment: .leading, spacing: Constants.Card.verticalSpacing) {
                HStack(alignment: .firstTextBaseline) {
                    Text(viewModel.title.uppercased())
                        .minimumScaleFactor(Constants.Card.titleTextScalingFactor)
                        .font(.eventTitleFont)
                    Text(Localization.GrandPrixCard.Top.round(viewModel.round))
                        .font(.eventRoundNumberFont)

                    Spacer()
                }

                EventComponentView(eventStatus: viewModel.eventStatus)
            }
            .frame(maxWidth: .infinity)
            .padding(Constants.Card.contentPadding)

            Spacer()

            switch viewModel.eventStatus {
            case .finished, .upcoming, .current:
                Image.chevronRight
                    .font(.chevronRightFont)
                    .padding(.trailing, Constants.Card.contentPadding)
            case .live:
                liveIndicatorComponent()
            }
        }
        .frame(height: Constants.Card.height)
        .background(
            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                .fill(eventStatusBackgroundStyler.color.gradient)
                .shadow(
                    radius: Constants.Card.shadowRadius,
                    x: Constants.Card.horizontalShadow,
                    y: Constants.Card.verticalShadow
                )
        )
    }

    func liveIndicatorComponent() -> some View {

        HStack {
            Circle()
                .frame(width: Constants.LiveComponent.circleSize)
                .scaleEffect(liveCircleAnimationAmount)
                .animation(
                    .easeInOut(
                        duration: Constants.LiveComponent.circleAnimationDuration).repeatForever(autoreverses: true),
                        value: liveCircleAnimationAmount
                    )
                .onAppear {
                    liveCircleAnimationAmount -= Constants.LiveComponent.circleAnimationDecrease
                }

            Text(Localization.GrandPrixCard.Label.live)
                .font(.liveTextFont)
        }
        .frame(width: Constants.LiveComponent.width, height: Constants.Card.height)
        .foregroundColor(.white)
        .background(Color.red)
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

    enum Card {

        static let width: CGFloat = UIScreen.main.bounds.width * 0.95
        static let height: CGFloat = 70
        static let cornerRadius: CGFloat = 10
        static let contentPadding: CGFloat = 12
        static let horizontalShadow: CGFloat = 3
        static let verticalShadow: CGFloat = 3
        static let verticalSpacing: CGFloat = 7
        static let shadowRadius: CGFloat = 3
        static let titleTextScalingFactor: CGFloat = 0.75
    }

    enum LiveComponent {

        static let width: CGFloat = 80
        static let circleSize: CGFloat = 12
        static let circleAnimationDuration: Double = 1
        static let circleAnimationAmount: Double = 1
        static let circleAnimationDecrease: Double = 0.6
    }
}

struct GrandPrixCardView_Previews: PreviewProvider {
    static var previews: some View {

        GrandPrixCardView(
            viewModel:
                GrandPrixCardViewModel(
                    round: 13,
                    title: "Emilia Romagna 2023",
                    eventStatus: .upcoming(details: "05-07 MAY")
                )
        )

        GrandPrixCardView(
            viewModel:
                GrandPrixCardViewModel(
                    round: 13,
                    title: "Emilia Romagna 2023",
                    eventStatus: .current(title: "FP1", details: "10:30h until start")
                )
        )

        GrandPrixCardView(
            viewModel:
                GrandPrixCardViewModel(
                    round: 3,
                    title: "Emilia Romagna 2023",
                    eventStatus: .live(title: "Race", details: "Lap 22 of 52")
                )
        )

        GrandPrixCardView(
            viewModel:
                GrandPrixCardViewModel(
                    round: 3,
                    title: "Bahrain 2023",
                    eventStatus: .finished(
                        drivers: [
                            .init(driverTicker: "HAM", value: .first),
                            .init(driverTicker: "LEC", value: .second),
                            .init(driverTicker: "VER", value: .third)
                        ]
                    )
                )
        )
    }
}
