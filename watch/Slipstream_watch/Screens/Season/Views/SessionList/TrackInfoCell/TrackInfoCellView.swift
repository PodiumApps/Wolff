import SwiftUI

struct TrackInfoCellView<ViewModel: TrackInfoCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        NavigationLink(destination: {
            Text("Track Info Details")
        }) {

            HStack {
                VStack(alignment: .leading, spacing: .Spacing.default0) {

                    Text("Track Info")
                        .font(.Body.semibold)

                    Text(viewModel.trackName)
                        .font(.Caption.regular)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: Constants.Background.cornerRadius)
                .fill(Color.Event.watchCompletedOrUpcomingEvent)
        )
    }
}

fileprivate enum Constants {

    enum Background {

        static let cornerRadius: CGFloat = 10
    }
}
