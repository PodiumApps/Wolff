import SwiftUI

struct LiveEventCardView<ViewModel: LiveEventCardViewModelRepresentable>: View {
    
    @State private var backgroundOpacity = Constants.Background.opacityStartValue

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        NavigationLink(destination: {
            SessionListView(viewModel: viewModel.sessionListViewModel)
        }) {
            HStack {
                VStack(alignment: .leading, spacing: .Spacing.default2) {
                    VStack(alignment: .leading) {
                        Text(viewModel.title)
                            .lineLimit(Constants.Title.lineLimit)
                            .minimumScaleFactor(Constants.Title.minimumScalingFactor)
                            .font(.Body.semibold)
                        HStack(spacing: .Spacing.default3) {
                            HStack {
                                Text(viewModel.country)
                                    .lineLimit(Constants.Country.lineLimit)
                                    .minimumScaleFactor(Constants.Country.minimumScalingFactor)
                                    .font(.Caption.semibold)
                            }

                            Spacer()

                            Text(Localization.LiveCardCell.Top.round(viewModel.round))
                                .font(.Caption2.medium)
                                .foregroundColor(.primary.opacity(Constants.Round.opacity))
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
            .padding(.horizontal, Constants.Card.horizontalPadding)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: Constants.Background.cornerRadius)
                .fill(Color.red)
                .opacity(backgroundOpacity)
                .animation(
                    .easeInOut(duration: Constants.Background.opacityAnimationDuration)
                    .repeatForever(autoreverses: true),
                    value: backgroundOpacity
                )
                .onAppear {
                    backgroundOpacity = Constants.Background.opacityFinalValue
                }
        )
    }

    private func createAboutToStartSection() -> some View {

        VStack(alignment: .leading) {
            Text(viewModel.sessionName)
                .font(.Caption.bold)
            Text(Localization.LiveCardCell.aboutToStart.uppercased())
                .font(.Caption.regular)
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
                            .font(.Caption.bold)
                        Text(hours != 1 ? Localization.LiveCardCell.Time.hours : Localization.LiveCardCell.Time.hours)
                            .font(.Caption2.semibold)
                            .foregroundColor(.red)
                    }
                }

                if minutes > 0 {
                    HStack(alignment: .bottom) {
                        Text(minutes.description)
                            .font(.Caption.bold)
                        Text(minutes != 1
                            ? Localization.LiveCardCell.Time.minutes
                            : Localization.LiveCardCell.Time.minute
                        )
                        .font(.Caption2.semibold)
                            .foregroundColor(.red)
                    }
                }
            }

            HStack(alignment: .bottom) {
                Text(Localization.LiveCardCell.to)
                    .font(.Caption2.semibold)
                    .foregroundColor(.red)
                Text(viewModel.sessionName)
                    .font(.Caption.bold)
            }
        }
    }

    private func createHappeningNowSection(podium: [String]) -> some View {

        VStack(alignment: .leading, spacing: .Spacing.default) {
            VStack(alignment: .leading) {
                Text(Localization.LiveCardCell.Title.now)
                    .font(.Caption2.semibold)
                    .foregroundColor(.red)
                Text(viewModel.sessionName)
                    .font(.Caption.bold)
            }

            HStack(spacing: .Spacing.default2) {
                ForEach(0 ..< podium.count, id: \.self) { index in
                    HStack(spacing: .Spacing.default) {
                        HStack(spacing: .Spacing.none) {
                            Text("\(index + 1)")
                            Text((index + 1).getPositionString)
                                .offset(y: Constants.OrdinalComponent.yOffset)
                        }
                        .font(.Caption2.regular)
                        Text(podium[index])
                            .font(.Caption2.bold)
                    }
                }
            }
        }
    }
}

fileprivate enum Constants {

    enum Card {

        static let horizontalPadding: CGFloat = 3
    }

    enum Background {

        static let cornerRadius: CGFloat = 17
        static let opacityAnimationDuration: CGFloat = 1.2
        static let opacityStartValue: Double = 0.35
        static let opacityFinalValue: Double = 0.25
    }

    enum Title {

        static let lineLimit: Int = 1
        static let minimumScalingFactor: CGFloat = 0.1
    }

    enum Country {

        static let lineLimit: Int = 1
        static let minimumScalingFactor: CGFloat = 0.1
    }

    enum OrdinalComponent {

        static let yOffset: CGFloat = -1
    }

    enum Round {

        static let opacity: CGFloat = 0.9
    }
}
