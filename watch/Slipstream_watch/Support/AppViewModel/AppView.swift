import SwiftUI

struct AppView<ViewModel: AppViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        switch viewModel.state {
        case .error(let error):
            Text(error)
        case .loading:
            ProgressView()
        case .results(let seasonViewModel, let standingsViewModel, let newsListViewModel):
            TabView {
                SeasonListView(viewModel: seasonViewModel)
                StandingsView(viewModel: standingsViewModel)
                NewsListView(viewModel: newsListViewModel)
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(viewModel: AppViewModel.make())
    }
}
