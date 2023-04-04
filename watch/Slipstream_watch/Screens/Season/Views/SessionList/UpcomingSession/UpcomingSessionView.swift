import SwiftUI

struct UpcomingSessionView<ViewModel: UpcomingSessionCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

//        Button(action: {

//        }) {
            HStack {
                VStack(alignment: .leading, spacing: .Spacing.default) {

                    Text(viewModel.sessionName)
                        .font(.Body.semibold)

                    if viewModel.date.isSessionToday {
                        Text("Today, \(DateFormatter.timeForSession.string(from: viewModel.date))")
                            .font(.Caption.regular)
                            .foregroundColor(.gray)
                    } else if viewModel.date.isSessionTomorrow {
                        Text("Tomorrow, \(DateFormatter.timeForSession.string(from: viewModel.date))")
                            .font(.Caption.regular)
                            .foregroundColor(.gray)
                    } else {
                        Text(DateFormatter.session.string(from: viewModel.date))
                            .font(.Caption.regular)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()
            }
//        }
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
