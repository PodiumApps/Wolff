import SwiftUI

struct FinishedEventCardView<ViewModel: FinishedEventCardViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Button(action: {
            viewModel.tapEvent()
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
                                .lineLimit(Constants.Round.lineLimit)
                                .font(.Caption2.semibold)
                        }
                        .foregroundColor(.gray)
                    }
                    
                    createPodiumSection(podium: viewModel.podium)
                }
            }
            .padding(.horizontal, Constants.Padding.horizontal)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: Constants.Background.cornerRadius)
                .fill(Color.Event.watchCompletedOrUpcomingEvent)
        )
    }

    private func createPodiumSection(podium: [String]) -> some View {

        VStack(alignment: .leading, spacing: .Spacing.default) {
            Text(Localization.FinishedCardCell.finished)
                .font(.Caption.bold)

            HStack(alignment: .bottom, spacing: .Spacing.default2) {
                ForEach(0 ..< podium.count, id: \.self) { index in
                    HStack(alignment: .bottom, spacing: .Spacing.default) {
                        HStack(spacing: .zero) {
                            Text("\(index + 1).")
                        }
                        .font(.Caption.medium)
                        .lineLimit(Constants.Podium.DriverTicker.lineLimit)
                        .minimumScaleFactor(Constants.Podium.DriverTicker.minimumScalingFactor)
                        .foregroundColor(.gray)

                        Text(podium[index])
                            .font(.Caption.semibold)
                            .lineLimit(Constants.Podium.DriverTicker.lineLimit)
                            .minimumScaleFactor(Constants.Podium.DriverTicker.minimumScalingFactor)
                    }
                }
            }
        }
    }
}

fileprivate enum Constants {

    enum Background {

        static let cornerRadius: CGFloat = 17
    }

    enum Title {

        static let lineLimit: Int = 1
        static let minimumScalingFactor: CGFloat = 0.1
    }

    enum Country {

        static let lineLimit: Int = 1
        static let minimumScalingFactor: CGFloat = 0.85
    }

    enum Round {

        static let opacity: CGFloat = 0.9
        static let lineLimit: Int = 1
    }

    enum Padding {

        static let horizontal: CGFloat = 2
    }

    enum Finished {

        static let opacity: CGFloat = 0.9
    }

    enum Podium {

        enum DriverTicker {

            static let lineLimit: Int = 1
            static let minimumScalingFactor: CGFloat = 0
        }

        enum OrdinalComponent {

            static let yOffset: CGFloat = -1
        }
    }
}
