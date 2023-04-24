import SwiftUI

struct SessionStandingsListView<ViewModel: SessionStandingsListViewModelRepresentable>: View {

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
            case .results(let cells):
                List(0 ..< cells.count, id: \.self) { index in
                    DriverStandingCellView(viewModel: viewModel.cells[index], position: index + 1)
                }
                .listStyle(.carousel)
            }
        }
        .navigationBarTitle(viewModel.sessionName)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadSession()
        }
    }
}
