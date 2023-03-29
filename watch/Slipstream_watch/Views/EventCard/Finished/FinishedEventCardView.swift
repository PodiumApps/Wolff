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
                                .font(Font.Body.bold)
                        }

                        HStack(spacing: .Spacing.default) {
                            HStack(spacing: .Spacing.default) {
                                Text(viewModel.country)
                                    .font(Font.Caption.semibold)
                            }

                            Spacer()

                            Text(Localization.LiveCardCell.Top.round(viewModel.round))
                                .font(Font.Caption2.medium)
                                .foregroundColor(.primary.opacity(Constants.Round.opacity))
                        }
                    }

                    createHappeningNowSection(podium: viewModel.podium)
                }
            }
            .padding(.horizontal, Constants.Padding.horizontal)
        }
    }

    private func createHappeningNowSection(podium: [String]) -> some View {

        VStack(alignment: .leading, spacing: 3) {
            Text(Localization.FinishedCardCell.finished)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.primary.opacity(0.9))

            HStack(spacing: .Spacing.default2) {
                ForEach(0 ..< podium.count, id: \.self) { index in
                    HStack(spacing: 3) {
                        HStack(spacing: 0) {
                            Text(String(index + 1))
                            Text((index + 1).getPositionString)
                                .offset(y: -2)
                        }
                            .font(.system(size: 9, weight: .medium))
                        Text(podium[index])
                            .font(.system(size: 10, weight: .bold))
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
