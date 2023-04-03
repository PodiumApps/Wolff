import SwiftUI

struct UpcomingSessionView<ViewModel: UpcomingSessionCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Button(action: {

        }) {

            VStack(alignment: .leading, spacing: .Spacing.default2) {

                Text(viewModel.sessionName)
                Text(viewModel.date.description)
            }
        }
    }
}

struct UpcomingSessionView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingSessionView(
            viewModel: UpcomingSessionCellViewModel(
                sessionName: "Practice 2",
                date: Date()
            )
        )
    }
}
