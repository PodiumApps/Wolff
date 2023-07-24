import SwiftUI

struct NewsDetailsView<ViewModel: NewsDetailsViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .Spacing.default2) {
                VStack(alignment: .leading, spacing: .Spacing.default) {
                    Text(viewModel.news.title)
                        .font(.Body.semibold)
                    Text(DateFormatter.newsDate.string(from: viewModel.news.date))
                        .font(.Caption.medium)
                        .foregroundColor(.gray)
                }
                Divider()
                Text(viewModel.news.body)
                    .font(.Body.regular)
                    .opacity(0.9)
            }
            .padding(.horizontal, 5)
        }
    }
}
