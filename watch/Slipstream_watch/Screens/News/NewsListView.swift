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
                Text(error)
            case .results(let news):
                List(0 ..< news.count, id: \.self) { index in
                    NewsCellView(viewModel: news[index])
                    Divider()
                        .padding(.vertical, 5)
                }

                Text("Source: fia.com")
                    .font(.Caption2.regular)
            }
        }
    }
}
