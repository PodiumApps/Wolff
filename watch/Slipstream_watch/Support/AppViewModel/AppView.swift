import SwiftUI

struct AppView<ViewModel: AppViewModelRepresentable>: View {

    @Environment(\.scenePhase) private var scenePhase

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            switch viewModel.state {
            case .error(let error):
                Text(error)
            case .loading:
                ProgressView()
            case .results(let seasonViewModel, let standingsViewModel, let newsListViewModel, let settingsViewModel):
                NavigationStack(path: $viewModel.route) {
                    TabView {
                        SeasonListView(viewModel: seasonViewModel)
                        NewsListView(viewModel: newsListViewModel)
                        StandingsView(viewModel: standingsViewModel)
                        SettingsView(viewModel: settingsViewModel)
                    }
                    .navigationDestination(for: AppNavigation.Route.self) { route in
                        switch route {
                        case .sessionsList(let viewModel):
                            SessionListView(viewModel: viewModel)
                        case .sessionStandingsList(let viewModel):
                            SessionStandingsListView(viewModel: viewModel)
                        case .newsDetails(let viewModel):
                            NewsDetailsView(viewModel: viewModel)
                        case .driverStandingDetails(let viewModel):
                            DriverStandingsDetailsView(viewModel: viewModel)
                        case .constructorStandingDetails(let viewModel):
                            ConstructorStandingsDetailsView(viewModel: viewModel)
                        case .activatePremium(let viewModel):
                            InAppPurchaseView(viewModel: viewModel)
                        }
                    }
                    .fullScreenCover(isPresented: $viewModel.presentPremiumSheet) {
                        InAppPurchaseView(viewModel: InAppPurchaseViewModel.make())
                    }
                }
            }
        }
        .onChange(of: scenePhase) { phase in

            switch phase {
            case .inactive:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { viewModel.action.send(.reloadServices) }
            default:
                return
            }
        }
    }
}
