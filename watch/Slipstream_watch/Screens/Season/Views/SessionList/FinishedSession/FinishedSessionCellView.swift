import SwiftUI

struct FinishedSessionCellView<ViewModel: FinishedSessionCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        NavigationLink(destination: {
            Text("Session Details")
        }) {
            HStack {
                VStack(alignment: .leading, spacing: Constants.Cell.verticalSpacing) {
                    Text(viewModel.session)
                        .font(.Body.semibold)

                    HStack(alignment: .bottom, spacing: .Spacing.default) {
                        Text(Localization.FinishedSessionCell.winner)
                            .font(.Caption.regular)
                        if let winner = viewModel.winners.first {
                            Text(winner)
                                .font(.Caption.semibold)
                        }
                    }
                    .foregroundColor(.gray)
                }

                Spacer()
            }
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: Constants.Background.cornerRadius)
                .fill(Color.Event.watchCompletedOrUpcomingEvent)
        )
    }

    private func createPodiumSection(podium: [String]) -> some View {

        VStack(alignment: .leading, spacing: .Spacing.default) {

            HStack(alignment: .bottom, spacing: .Spacing.default2) {
                ForEach(0 ..< podium.count, id: \.self) { index in
                    HStack(alignment: .bottom, spacing: .Spacing.default) {
                        HStack(spacing: .zero) {
                            Text("\(index + 1)")
                            Text((index + 1).getPositionString)
                                .offset(y: Constants.Podium.OrdinalComponent.yOffset)
                        }
                        .font(.Caption2.medium)
                        .lineLimit(Constants.Podium.DriverTicker.lineLimit)
                        .minimumScaleFactor(Constants.Podium.DriverTicker.minimumScalingFactor)
                        Text(podium[index])
                            .font(.Caption2.bold)
                            .lineLimit(Constants.Podium.DriverTicker.lineLimit)
                            .minimumScaleFactor(Constants.Podium.DriverTicker.minimumScalingFactor)
                    }

                    Spacer()
                }
            }
        }
    }
}

fileprivate enum Constants {

    enum Background {

        static let cornerRadius: CGFloat = 10
    }

    enum Cell {

        static let verticalSpacing: CGFloat = 2
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

struct FinishedCellView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedSessionCellView(
            viewModel: FinishedSessionCellViewModel(
                session: "Race",
                winners: ["VER", "ALO", "LEC"]
            )
        )
    }
}
