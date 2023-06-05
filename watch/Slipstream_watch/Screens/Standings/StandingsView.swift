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
                case .results(let driverCells, let constructorCells):
                    VStack {
                        Form {
                            Picker(Localization.StandingsListView.selectionLabel, selection: $viewModel.selection) {
                                ForEach(StandingsViewModel.Selection.allCases) { selection in
                                    HStack {
                                        Text(selection.rawValue.capitalized)
                                            .tag(selection)
                                        Spacer()
                                    }
                                }
                            }
                            .pickerStyle(.navigationLink)

                            switch viewModel.selection {
                            case .drivers: buildDriverStandingsListView(cells: driverCells)
                            case .constructors: buildConstructorStandingsListView(cells: constructorCells)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Localization.StandingsListView.screenTitle)
        }
    }

    private func buildDriverStandingsListView(cells: [DriverStandingsCellViewModel]) -> some View {

        ForEach(cells) { cell in
            DriverStandingsCellView(viewModel: cell)
        }
        .listStyle(.carousel)
        .frame(width: .infinity, height: .infinity)
    }

    private func buildConstructorStandingsListView(cells: [ConstructorStandingsCellViewModel]) -> some View {

        ForEach(cells) { cell in
            ConstructorStandingsCellView(viewModel: cell)
        }
        .listStyle(.carousel)
        .frame(width: .infinity, height: .infinity)
    }
}
