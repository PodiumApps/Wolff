import SwiftUI

struct TrackInfoCellView<ViewModel: TrackInfoCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        NavigationLink(destination: {
            TrackInfoView(viewModel: TrackInfoViewModel(
                raceDistance: viewModel.event.raceDistance,
                trackLength: viewModel.event.length,
                firstGrandPrix: viewModel.event.firstGrandPrix,
                lapRecord: viewModel.event.lapRecord
            ))
        }) {
            HStack {
                VStack(alignment: .leading, spacing: .Spacing.default0) {

                    Text(Localization.TrackInfo.screenTitle)
                        .font(.Body.semibold)

                    Text(viewModel.event.name)
                        .font(.Caption.medium)
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
}

fileprivate enum Constants {

    enum Background {

        static let cornerRadius: CGFloat = 10
    }
}
