import SwiftUI

struct CalledOffEventCardView<ViewModel: CalledOffEventCardViewModelRepresentable>: View {

    @ObservedObject var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Button(action: {}) {
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

                    Text("CALLED OFF")
                        .font(.Caption.bold)
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal, Constants.Padding.horizontal)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: Constants.Background.cornerRadius)
                .fill(Color.Event.watchCompletedOrUpcomingEvent)
        )
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
}

