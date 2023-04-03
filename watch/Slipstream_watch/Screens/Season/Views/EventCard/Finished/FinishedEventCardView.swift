import SwiftUI

struct FinishedEventCardView<ViewModel: FinishedEventCardViewModelRepresentable>: View {

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

                    createPodiumSection(podium: viewModel.podium)
                }
            }
            .padding(.horizontal, Constants.Padding.horizontal)
        }
    }

    private func createPodiumSection(podium: [String]) -> some View {

        VStack(alignment: .leading, spacing: .Spacing.default) {
            Text(Localization.FinishedCardCell.finished)
                .font(.Caption2.semibold)
                .foregroundColor(.primary.opacity(Constants.Finished.opacity))

            HStack(spacing: .Spacing.default2) {
                ForEach(0 ..< podium.count, id: \.self) { index in
                    HStack(spacing: .Spacing.default) {
                        HStack(spacing: .Spacing.none) {
                            Text("\(index + 1)")
                            Text((index + 1).getPositionString)
                                .offset(y: Constants.Podium.OrdinalComponent.yOffset)
                        }
                        .font(.Caption.regular)
                        .lineLimit(Constants.Podium.DriverTicker.lineLimit)
                        .minimumScaleFactor(Constants.Podium.DriverTicker.minimumScalingFactor)
                        Text(podium[index])
                            .font(.Caption.bold)
                            .lineLimit(Constants.Podium.DriverTicker.lineLimit)
                            .minimumScaleFactor(Constants.Podium.DriverTicker.minimumScalingFactor)
                    }
                }
            }
        }
    }
}

fileprivate enum Constants {

    enum Title {

        static let lineLimit: Int = 1
        static let minimumScalingFactor: CGFloat = 0.1
    }

    enum Country {

        static let lineLimit: Int = 1
        static let minimumScalingFactor: CGFloat = 0.1
    }

    enum Round {

        static let opacity: CGFloat = 0.9
    }

    enum Padding {

        static let horizontal: CGFloat = 3
    }

    enum Finished {

        static let opacity: CGFloat = 0.9
    }

    enum Podium {

        enum DriverTicker {

            static let lineLimit: Int = 1
            static let minimumScalingFactor: CGFloat = 0.1
        }

        enum OrdinalComponent {

            static let yOffset: CGFloat = -1
        }
    }
}

struct FinishedEventCardView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedEventCardView(
            viewModel: FinishedEventCardViewModel(
                id: .init("event"),
                title: "Monza",
                country: "Italy",
                round: 8,
                podium: ["ALO", "LEC", "VER"]
            )
        )
    }
}
