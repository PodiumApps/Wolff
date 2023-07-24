import SwiftUI

struct NewsListView<ViewModel: NewsListViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .error(let error):
                VStack {
                    Spacer()
                    Text(error)
                        .font(.caption)
                    Spacer()
                    Button("Try again") {
                        viewModel.action.send(.reloadService)
                    }
                }
            case .results(let news):
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(0 ..< news.count, id: \.self) { index in
                            NewsCellView(viewModel: news[index])
                            Divider()
                                .padding(.vertical, .Spacing.default)
                        }

                        Text(Localization.NewsListView.sourceLabel)
                            .font(.Caption2.regular)
                            .padding(.top, .Spacing.default)
                    }
                    .padding(.horizontal, .Spacing.default)
                }
            }
        }
        .navigationTitle(Localization.NewsListView.screenTitle)
    }
}
