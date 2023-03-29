import SwiftUI

struct UpcomingEventCardView<ViewModel: UpcomingEventCardViewModelRepresentable>: View {

    private var viewModel: ViewModel

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
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .font(.Body.semibold)
                        HStack(spacing: .Spacing.default3) {
                            HStack {
                                Text(viewModel.country)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                                    .font(.system(size: 12, weight: .semibold))
                            }

                            Spacer()

                            Text("Round \(viewModel.round)")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.primary.opacity(0.9))
                        }
                    }

                    switch viewModel.state {
                    case .moreThanFortyEightHours(let date):
                        Text(date)
                            .font(.system(size: 13, weight: .regular))
                    case .lessThanFortyEightHours(let hours, let minutes):
                        createLessThanFortyEightHoursLeftSection(
                            hours: hours,
                            minutes: minutes
                        )
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 3)
        }
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
                            .font(.system(size: 12, weight: .bold))
                        Text(hours != 1 ? "HOURS" : "HOUR")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }

                if minutes > 0 {
                    HStack(alignment: .bottom) {
                        Text(minutes.description)
                            .font(.system(size: 12, weight: .bold))
                        Text(minutes != 1 ? "MINUTES" : "MINUTE")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
            }

            HStack(alignment: .bottom) {
                Text("To")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
                Text(viewModel.sessionName)
                    .font(.system(size: 12, weight: .bold))
            }
        }
    }


}

struct UpcomingEventCardView_Previews: PreviewProvider {
    static var previews: some View {

        UpcomingEventCardView(
            viewModel: UpcomingEventCardViewModel(
                id: .init("event"),
                title: "Silverstone",
                country: "Great Britain",
                round: 11,
                start: "30 May",
                end: "2 Jun",
                sessionName: "Practice 3",
                timeInterval: 20000
            )
        )
    }
}
