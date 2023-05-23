import SwiftUI

struct StandingsView<ViewModel: StandingsViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        NavigationStack(path: $viewModel.route) {
            Group {
                switch viewModel.state {
                case .error(let error):
                    Text(error)
                case .loading:
                    ProgressView()
                case .results:
                    VStack {
                        VStack {
                            Picker("Selection", selection: $viewModel.selection) {
                                ForEach(DriverStandingsEntryPointCellViewModel.Selection.allCases, id: \.self) { selection in
                                    Text(selection.rawValue.capitalized)
                                }
                            }
                        }
                        .pickerStyle(.navigationLink)

                        switch viewModel.selection {
                        case .drivers: buildDriverStandingsListView()
                        case .constructors: buildConstructorStandingsListView()
                        }
                    }
                }
            }
            .navigationTitle("Standings")
            .navigationDestination(for: StandingsNavigation.Route.self) { route in
                switch route {
                default: EmptyView()
                }
            }
        }
    }

    private func buildDriverStandingsListView() -> some View {

        return EmptyView()
    }

    private func buildConstructorStandingsListView() -> some View {

        return EmptyView()
    }
}
