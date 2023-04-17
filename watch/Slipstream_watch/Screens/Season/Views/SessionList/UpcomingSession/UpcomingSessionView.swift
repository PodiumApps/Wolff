import SwiftUI

struct UpcomingSessionView<ViewModel: UpcomingSessionCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        NavigationLink(destination: {
            Text("Session Details")
        }) {
            HStack {
                VStack(alignment: .leading, spacing: .Spacing.default0) {

                    Text(viewModel.sessionName)
                        .font(.Body.semibold)

                    if viewModel.date.isSessionToday {
                        Text(Localization.SessionTime.today(DateFormatter.timeForSession.string(from: viewModel.date)))
                            .font(.Caption.regular)
                            .foregroundColor(.gray)
                    } else if viewModel.date.isSessionTomorrow {
                        Text(Localization.SessionTime.tomorrow(
                            DateFormatter.timeForSession.string(from: viewModel.date)
                        ))
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
        UpcomingSessionView(
            viewModel: UpcomingSessionCellViewModel(
                sessionName: "Practice 2",
                date: Date()
            )
        )
    }
}
