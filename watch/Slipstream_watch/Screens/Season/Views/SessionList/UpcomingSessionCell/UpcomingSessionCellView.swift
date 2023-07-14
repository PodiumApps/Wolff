import SwiftUI

struct UpcomingSessionCellView<ViewModel: UpcomingSessionCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack {
            VStack(alignment: .leading, spacing: .Spacing.default0) {

                Text(viewModel.sessionName)
                    .font(.Body.semibold)

                Text(viewModel.formattedDate)
                    .font(.Caption.regular)
                    .foregroundColor(.gray)
            }

            Spacer()
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

struct UpcomingSessionView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingSessionCellView(
            viewModel: UpcomingSessionCellViewModel(
                sessionName: "Practice 2",
                date: Date()
            )
        )
    }
}
