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
                            .font(.Body.semibold)
                        HStack(spacing: .Spacing.default3) {
                            HStack(spacing: .Spacing.default) {
                                Text("🇧🇪")
                                Text(viewModel.country)
                                    .font(.system(size: 12, weight: .medium))
                            }
                            Text("Round \(viewModel.round.description)")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color.red)
                        }
                    }

                    if let state = viewModel.state {
                        makeBottomSection(state: state)
                    }

//                    VStack(alignment: .leading, spacing: 1) {
//                        Text(viewModel.sessionName)
//                            .font(.system(size: 12, weight: .bold))
//                        Text("Happening Now".uppercased())
//                            .font(.system(size: 11, weight: .medium))
//                            .foregroundColor(.red)
//                    }
                }

                Spacer()
            }
        }
        .background(Color.red.opacity(0.27))
        .buttonBorderShape(
            .roundedRectangle(radius: 10)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
    }

    private func makeBottomSection(state: LiveEventCardViewModel.State) -> some View {

        VStack(alignment: .leading) {
            switch state {
            case .aboutToStart:
                Text(viewModel.sessionName)
                    .font(.system(size: 12, weight: .bold))
                Text("ABOUT TO START")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.red)

            case .betweenOneMinuteAndFourHoursToGo(let hours, let minutes):
                HStack(alignment: .bottom, spacing: .Spacing.default2) {
                    if hours > 0 {
                        HStack(alignment: .bottom) {
                            Text(hours.description)
                                .font(.system(size: 12, weight: .bold))
                            Text(hours != 1 ? "HOURS" : "HOUR")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.red)
                        }
                    }

                    if minutes > 0 {
                        HStack(alignment: .bottom) {
                            Text(minutes.description)
                                .font(.system(size: 12, weight: .bold))
                            Text(minutes != 1 ? "MINUTES" : "MINUTE")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.red)
                        }
                    }
                }

                HStack(alignment: .bottom) {
                    Text("To")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.red)
                    Text(viewModel.sessionName)
                        .font(.system(size: 12, weight: .bold))
                }

            case .happeningNow(let podium):
                Text(viewModel.sessionName)
                    .font(.system(size: 12, weight: .bold))
                Text("HAPPENING NOW")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.red)

                HStack(spacing: .Spacing.default3) {
                    ForEach(0 ..< podium.count, id: \.self) { index in
                        HStack {
                            HStack(spacing: 0) {
                                Text(String(index + 1))
                                Text((index + 1).getPositionString)
                                    .font(.system(size: 10, weight: .medium))
                                    .offset(y: -2)
                            }
                            .font(.system(size: 11, weight: .medium))
                            Text(podium[index])
                        }
                        .font(.system(size: 12, weight: .bold))
                    }
                }
                .padding(.top, .Spacing.default)
            }
        }
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
                timeInterval: .init(0),
                sessionName: "Qualifying",
                podium: ["VER", "LEC", "ALO"]
            )
        )
    }
}
