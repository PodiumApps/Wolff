import SwiftUI

struct NewsCellView<ViewModel: NewsCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Button(action: {
            viewModel.action.send(.openDetails)
        }) {
            VStack(alignment: .leading, spacing: 5) {
                Text(viewModel.news.title)
                    .font(.Body.semibold)
                Text(viewModel.enumeration)
                    .font(.Caption.medium)
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(.plain)
    }
}
