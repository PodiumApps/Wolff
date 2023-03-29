import SwiftUI

struct LiveEventCardView<ViewModel: LiveEventCardViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        Button(action: {

        }) {
            HStack {
                VStack(alignment: .leading, spacing: .Spacing.default2) {
                    VStack(alignment: .leading) {
                        Text(viewModel.title)
                            .lineLimit(Constants.Title.lineLimit)
                            .minimumScaleFactor(Constants.Title.scalingFactor)
                            .font(.Body.semibold)
                        HStack(spacing: .Spacing.default3) {
                            HStack(spacing: .Spacing.default) {
                                Text(viewModel.country)
                                    .font(Font.Caption.semibold)
                            }
                            Text(Localization.LiveCardCell.Top.round(viewModel.round))
                                .font(Font.Caption2.medium)
                                .foregroundColor(Color.red)
                        }
                    }

                    switch viewModel.state {
                    case .aboutToStart:
                        createAboutToStartSection()
                    case .betweenOneMinuteAndFourHoursToGo(let hours, let minutes):
                        createBetweenOneMinuteAndFourHoursToGoSection(
                            hours: hours,
                            minutes: minutes
                        )
                    case .happeningNow(let podium):
                        createHappeningNowSection(podium: podium)
                    }
                }

                Spacer()
            }
        }
    }

    private func createAboutToStartSection() -> some View {

        VStack(alignment: .leading) {
            Text(viewModel.sessionName)
                .font(Font.Caption.bold)
            Text(Localization.LiveCardCell.aboutToStart.uppercased())
                .font(Font.Caption.regular)
                .foregroundColor(.red)
        }
    }

    private func createBetweenOneMinuteAndFourHoursToGoSection(
        hours: Int,
        minutes: Int
    ) -> some View {

        VStack(alignment: .leading) {
            HStack(alignment: .bottom, spacing: .Spacing.default2) {
                if hours > 0 {
                    HStack(alignment: .bottom) {
                        Text(hours.description)
                            .font(Font.Caption.bold)
                        Text(hours != 1 ? Localization.LiveCardCell.Time.hours : Localization.LiveCardCell.Time.hours)
                            .font(Font.Caption2.semibold)
                            .foregroundColor(.red)
                    }
                }

                if minutes > 0 {
                    HStack(alignment: .bottom) {
                        Text(minutes.description)
                            .font(Font.Caption.bold)
                        Text(minutes != 1
                                ? Localization.LiveCardCell.Time.minutes
                                : Localization.LiveCardCell.Time.minute
                        )
                        .font(Font.Caption2.semibold)
                            .foregroundColor(.red)
                    }
                }
            }

            HStack(alignment: .bottom) {
                Text(Localization.LiveCardCell.to)
                    .font(Font.Caption2.semibold)
                    .foregroundColor(.red)
                Text(viewModel.sessionName)
                    .font(Font.Caption.bold)
            }
        }
    }

    private func createHappeningNowSection(podium: [String]) -> some View {

        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading) {
                Text(viewModel.sessionName)
                    .font(Font.Caption.bold)
                Text(Localization.LiveCardCell.Title.now)
                    .font(Font.Caption2.semibold)
                    .foregroundColor(.red)
            }

            HStack(spacing: .Spacing.default3) {
                ForEach(0 ..< podium.count, id: \.self) { index in
                    HStack {
                        HStack(spacing: 0) {
                            Text(String(index + 1))
                            Text((index + 1).getPositionString)
                                .font(Font.Caption2.medium)
                                .offset(y: -2)
                        }
                        .font(Font.Caption2.semibold)
                        Text(podium[index])
                    }
                    .font(Font.Caption.bold)
                }
            }
        }
    }
}

fileprivate enum Constants {

    enum Title {

        static let lineLimit: Int = 1
        static let scalingFactor: CGFloat = 0.1
    }
}

struct LiveEventCardView_Previews: PreviewProvider {
    static var previews: some View {
        LiveEventCardView(
            viewModel: LiveEventCardViewModel(
                id: .init("event"),
                title: "Spa-Francorchamps",
                country: "Belgium",
                round: 18,
                timeInterval: .init(150),
                sessionName: "Qualifying"
                //podium: ["VER", "LEC", "ALO"]
            )
        )
    }
}
