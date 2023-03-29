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
                        HStack(alignment: .bottom) {
                            Text(viewModel.title)
                                .font(.Body.bold)
                        }

                        HStack(spacing: .Spacing.default) {
                            HStack(spacing: .Spacing.default) {
                                Text(viewModel.country)
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
                                .offset(y: Constants.OrdinalComponent.yOffset)
                        }
                        .font(.Caption2.regular)
                        Text(podium[index])
                            .font(.Caption2.bold)
                    }
                }
            }
        }
    }
}

fileprivate enum Constants {

    enum Round {

        static let opacity: CGFloat = 0.9
    }

    enum Padding {

        static let horizontal: CGFloat = 3
    }

    enum Finished {

        static let opacity: CGFloat = 0.9
    }

    enum OrdinalComponent {

        static let yOffset: CGFloat = -1
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
