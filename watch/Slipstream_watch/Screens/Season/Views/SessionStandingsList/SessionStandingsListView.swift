import SwiftUI

struct SessionStandingsListView<ViewModel: SessionStandingsListViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .error(let error):
                    Text(error)
                case .loading:
                    ProgressView()
                case .results(let cells):
                    List(0 ..< cells.count, id: \.self) { index in
                        DriverStandingCellView(viewModel: viewModel.cells[index])
                    }
                }
            }
            .navigationTitle(viewModel.sessionName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
