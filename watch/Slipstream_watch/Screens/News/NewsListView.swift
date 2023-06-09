import SwiftUI

struct NewsListView<ViewModel: NewsListViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        NavigationStack(path: $viewModel.route) {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .error(let error):
                    Text(error)
                case .results(let news):
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ForEach(0 ..< news.count, id: \.self) { index in
                                NewsCellView(viewModel: news[index])
                                Divider()
                                    .padding(.vertical, Constants.Divider.verticalPadding)
                            }

                            Text(Localization.NewsListView.sourceLabel)
                                .font(.Caption2.regular)
                                .padding(.top, Constants.Source.topPadding)
                        }
                        .padding(.horizontal, Constants.Title.horizontalPadding)
                    }
                }
            }
            .navigationTitle(Localization.NewsListView.screenTitle)
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: NewsNavigation.Route.self) { route in
                switch route {
                case .newsDetails(let viewModel):
                    NewsDetailsView(viewModel: viewModel)
                }
            }
        }
    }
}

fileprivate enum Constants {

    enum Divider {

        static let verticalPadding: CGFloat = 5
    }

    enum Title {

        static let horizontalPadding: CGFloat = 2
    }

    enum Source {

        static let topPadding: CGFloat = 5
    }
}
