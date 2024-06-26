import SwiftUI

struct LiveSessionCellView<ViewModel: LiveSessionCellViewModelRepresentable>: View {

    @State private var backgroundOpacity = Constants.Background.opacityStartValue
    @State private var timer: Timer? = nil

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    private func startAnimation() {

        self.timer?.invalidate()

        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.Background.opacityAnimationDuration,
            repeats: false
        ) { _ in

            if self.backgroundOpacity == Constants.Background.opacityStartValue {
                self.backgroundOpacity = Constants.Background.opacityFinalValue
            } else {
                self.backgroundOpacity = Constants.Background.opacityStartValue
            }

            startAnimation()
        }
    }

    var body: some View {

        Button(action: {
            viewModel.action.send(.tapSession)
        }) {
            HStack {
                VStack(alignment: .leading, spacing: .Spacing.default) {
                    Text(viewModel.sessionName)
                        .font(.Body.semibold)

                    switch viewModel.state {
                    case .aboutToStart:
                        Text(Localization.LiveCardCell.aboutToStart.uppercased())
                            .font(.Caption.regular)
                            .foregroundColor(.red)
                    case .happeningNow(let podium, let status):
                        createPodiumSection(podium: podium, status: status)
                    case .betweenOneMinuteAndFourHoursToGo(let date):
                        createDateSection(date: date)
                    }
                }

                Spacer()
            }
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

    private func createPodiumSection(podium: [String], status: LiveSession.Status) -> some View {

        VStack(alignment: .leading, spacing: .Spacing.default) {

            HStack(alignment: .bottom, spacing: .Spacing.default2) {
                ForEach(0 ..< 3, id: \.self) { index in
                    HStack(alignment: .bottom, spacing: .Spacing.default) {
                        HStack(spacing: .zero) {
                            Text(Localization.Podium.ordinalComponent(index + 1))
                                .opacity(Constants.Podium.OrdinalComponent.opacity)
                        }
                        .font(.Caption.medium)
                        .lineLimit(Constants.Podium.DriverTicker.lineLimit)

                        Text(podium.count >= 3 ? podium[index] : "-")
                            .font(.Caption.semibold)
                            .lineLimit(Constants.Podium.DriverTicker.lineLimit)
                    }
                }
            }

            if status.redFlag {
                Text("Red Flag")
                    .font(.Caption.semibold)
                    .foregroundColor(Color.red)
            }

            if !status.state.isEmpty {
                Text(status.state)
                    .font(.Caption.regular)
            }
        }
    }

    private func createDateSection(date: Date) -> some View {

        Text(Localization.SessionTime.today(DateFormatter.timeForSession.string(from: date)))
            .font(.Caption.regular)
            .foregroundColor(.red)
    }
}

fileprivate enum Constants {

    enum Background {

        static let cornerRadius: CGFloat = 10
        static let opacityAnimationDuration: CGFloat = 1.2
        static let opacityStartValue: Double = 0.35
        static let opacityFinalValue: Double = 0.25
    }

    enum Podium {

        enum DriverTicker {

            static let lineLimit: Int = 1
            static let minimumScalingFactor: CGFloat = 0
        }

        enum OrdinalComponent {

            static let yOffset: CGFloat = -1
            static let opacity: CGFloat = 0.70
        }
    }
}
