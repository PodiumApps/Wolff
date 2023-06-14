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
            NavigationStack(path: $viewModel.route) {
                TabView {
                    SeasonListView(viewModel: seasonViewModel)
                    NewsListView(viewModel: newsListViewModel)
                    StandingsView(viewModel: standingsViewModel)
                    Text("Settings")
                }
                .navigationDestination(for: AppNavigation.Route.self) { route in
                    switch route {
                    case .sessionsList(let viewModel):
                        SessionListView(viewModel: viewModel)
                    case .sessionStandingsList(let viewModel):
                        SessionStandingsListView(viewModel: viewModel)
                    case .newsDetails(let viewModel):
                        NewsDetailsView(viewModel: viewModel)
                    }
                }
                .sheet(isPresented: $viewModel.presentPremiumSheet) {
                    InAppPurchaseView(viewModel: InAppPurchaseViewModel.make())
                }
            }
            
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(viewModel: AppViewModel.make())
    }
}
