import SwiftUI

struct UpcomingEventCardView<ViewModel: UpcomingEventCardViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
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
                                .lineLimit(Constants.Round.lineLimit)
                                .font(.Caption2.semibold)
                        }
                        .foregroundColor(.gray)
                    }

                    switch viewModel.state {
                    case .moreThanFortyEightHours(let date):
                        Text(date)
                            .font(.Caption.semibold)
                    case .lessThanFortyEightHours(let hours, let minutes):
                        createLessThanFortyEightHoursLeftSection(
                            hours: hours,
                            minutes: minutes
                        )
                    }
                }

                Spacer()
            }
            .padding(.horizontal, Constants.Padding.horizontal)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: Constants.Background.cornerRadius)
                .fill(Color.Event.watchCompletedOrUpcomingEvent)
        )
    }

    private func createLessThanFortyEightHoursLeftSection(
        hours: Int,
        minutes: Int
    ) -> some View {

        VStack(alignment: .leading) {
            HStack(alignment: .bottom, spacing: .Spacing.default2) {
                if hours > 0 {
                    HStack(alignment: .bottom) {
                        Text(hours.description)
                            .font(.Caption.bold)
                        Text(hours != 1
                             ? Localization.LiveCardCell.Time.hours
                             : Localization.LiveCardCell.Time.hour
                        )
                            .font(.Caption2.bold)
                            .foregroundColor(.gray)
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
                            .foregroundColor(.gray)
                    }
                }
            }

            HStack(alignment: .bottom) {
                Text(Localization.LiveCardCell.to)
                    .font(.Caption2.bold)
                    .foregroundColor(.gray)
                Text(viewModel.sessionName)
                    .font(.Caption.bold)
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

    enum Padding {

        static let horizontal: CGFloat = 2
    }

    enum Country {

        static let lineLimit: Int = 1
        static let minimumScalingFactor: CGFloat = 0.1
    }

    enum Round {

        static let opacity: CGFloat = 0.9
        static let lineLimit: Int = 1
    }
}
