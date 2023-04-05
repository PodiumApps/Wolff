import SwiftUI

struct FinishedSessionCellView<ViewModel: FinishedSessionCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Button(action: {

        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.session)
                        .font(.Body.semibold)

                    HStack(alignment: .bottom, spacing: .Spacing.default) {
                        Text("🏆")
                            .font(.Caption2.medium)
                            .offset(y:-1)
                        Text(viewModel.winners.first!)
                            .font(.Caption.regular)
                    }
                    .foregroundColor(.gray)
                }

                Spacer()
            }
        }
    }

    private func createPodiumSection(podium: [String]) -> some View {

        VStack(alignment: .leading, spacing: .Spacing.default) {

            HStack(alignment: .bottom, spacing: .Spacing.default2) {
                ForEach(0 ..< podium.count, id: \.self) { index in
                    HStack(alignment: .bottom, spacing: .Spacing.default) {
                        HStack(spacing: .Spacing.none) {
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
//            .foregroundColor(.gray)
        }
    }
}

fileprivate enum Constants {

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
