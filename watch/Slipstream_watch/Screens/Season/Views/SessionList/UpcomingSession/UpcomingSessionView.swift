import SwiftUI

struct UpcomingSessionView<ViewModel: UpcomingSessionCellViewModelRepresentable>: View {

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
                    Text(DateFormatter.session.string(from: viewModel.date))
                        .font(.Caption.regular)
                }

                Spacer()
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
