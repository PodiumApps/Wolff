import SwiftUI

struct LiveSessionCellView<ViewModel: LiveSessionCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .Spacing.default) {
                Text(viewModel.sessionName)
                    .font(.Body.semibold)

                switch viewModel.state {
                case .aboutToStart:
                    Text(Localization.LiveCardCell.aboutToStart.uppercased())
                        .font(.Caption.regular)
                        .foregroundColor(.red)
                case .happeningNow(let podium):
                    createPodiumSection(podium: podium)
                case .betweenOneMinuteAndFourHoursToGo(let date):
                    createDateSection(date: date)
                }
            }

            Spacer()
        }
    }

    private func createPodiumSection(podium: [String]) -> some View {

        VStack(alignment: .leading, spacing: .Spacing.default) {

            HStack(alignment: .bottom, spacing: .Spacing.default2) {
                ForEach(0 ..< podium.count, id: \.self) { index in
                    HStack(spacing: .Spacing.default) {
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
                }
            }
        }
    }

    private func createDateSection(date: Date) -> some View {

        Text("Today, \(DateFormatter.timeForSession.string(from: date))")
            .font(.Caption.regular)
            .foregroundColor(.red)
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
                podium: ["ALO", "HAM", "VER"], state: .aboutToStart
            )
        )
    }
}
