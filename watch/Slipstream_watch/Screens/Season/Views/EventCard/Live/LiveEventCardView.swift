import SwiftUI

struct LiveEventCardView<ViewModel: LiveEventCardViewModelRepresentable>: View {
    
    @State private var backgroundOpacity = Constants.Background.opacityStartValue
    @State private var timer: Timer? = nil

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    private func startAnimation() {

        self.timer?.invalidate()

        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.Background.opacityAnimationDuration,
            repeats: false
        ) { _ in

            self.backgroundOpacity = self.backgroundOpacity == Constants.Background.opacityStartValue
                ? Constants.Background.opacityFinalValue
                : Constants.Background.opacityStartValue

            startAnimation()
        }
    }

    var body: some View {
        
        Button(action: {
            viewModel.action.send(.tapEvent)
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
                                .font(.Caption2.semibold)
                                .foregroundColor(.red)
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
                    .easeInOut(duration: Constants.Background.opacityAnimationDuration),
                    value: backgroundOpacity
                )
        )
        .onAppear {
            self.startAnimation()
        }
    }

    private func createAboutToStartSection() -> some View {

        VStack(alignment: .leading) {
            Text(viewModel.sessionName)
                .font(.Caption.bold)
            Text(Localization.LiveCardCell.aboutToStart.uppercased())
                .font(.Caption.semibold)
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
                            .font(.Caption2.bold)
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
                        .font(.Caption2.bold)
                            .foregroundColor(.red)
                    }
                }
            }

            HStack(alignment: .bottom) {
                Text(Localization.LiveCardCell.to)
                    .font(.Caption2.bold)
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
                    .font(.Caption.semibold)
                    .foregroundColor(.red)
                Text(viewModel.sessionName)
                    .font(.Caption.bold)
            }

            HStack(alignment: .bottom, spacing: .Spacing.default2) {
                ForEach(0 ..< podium.count, id: \.self) { index in
                    HStack(alignment: .bottom, spacing: .Spacing.default) {
                        HStack(spacing: .zero) {
                            Text(Localization.Podium.ordinalComponent(index + 1))
                                .opacity(Constants.Podium.OrdinalComponent.opacity)
                        }
                        .font(.Caption.medium)
                        .lineLimit(Constants.Podium.DriverTicker.lineLimit)

                        Text(podium[index])
                            .font(.Caption.semibold)
                            .lineLimit(Constants.Podium.DriverTicker.lineLimit)
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
        static let opacityAnimationDuration: CGFloat = 1.1
        static let opacityStartValue: Double = 0.35
        static let opacityFinalValue: Double = 0.25
    }

    enum Title {

        static let lineLimit: Int = 1
        static let minimumScalingFactor: CGFloat = 0.1
    }

    enum Country {

        static let lineLimit: Int = 1
        static let minimumScalingFactor: CGFloat = 0.85
    }

    enum Podium {

        enum DriverTicker {

            static let lineLimit: Int = 1
            static let minimumScalingFactor: CGFloat = 0.85
        }

        enum OrdinalComponent {

            static let opacity: CGFloat = 0.70
            static let yOffset: CGFloat = -1
        }
    }

    enum Round {

        static let opacity: CGFloat = 0.9
    }
}
