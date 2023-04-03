import SwiftUI

struct LiveSessionCellView<ViewModel: LiveSessionCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        Button(action: {

        }) {
            HStack {
                VStack(alignment: .leading, spacing: .Spacing.default) {
                    Text(viewModel.sessionName)
                        .font(.Body.semibold)
                    Text(Localization.LiveCardCell.Title.now)
                        .font(.Caption2.regular)

                    createPodiumSection(podium: viewModel.podium)
                }

                Spacer()
            }
        }
    }

    private func createPodiumSection(podium: [String]) -> some View {

        VStack(alignment: .leading, spacing: .Spacing.default) {

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

struct LiveSessionCellView_Previews: PreviewProvider {
    static var previews: some View {
        LiveSessionCellView(
            viewModel: LiveSessionCellViewModel(
                sessionName: "Practice 3",
                podium: ["ALO", "HAM", "VER"]
            )
        )
    }
}
