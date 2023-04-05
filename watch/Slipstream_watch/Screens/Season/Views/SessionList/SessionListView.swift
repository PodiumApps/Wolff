import SwiftUI

struct SessionListView<ViewModel: SessionListViewModelRepresentable>: View {

    private let viewModel: ViewModel

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
                        Group {
                            switch cells[index] {
                            case .live(let viewModel):
                                NavigationLink(destination: {

                                }) {
                                    LiveSessionCellView(viewModel: viewModel)
                                }
                            case .upcoming(let viewModel):
                                NavigationLink(destination: {

                                }) {
                                    UpcomingSessionView(viewModel: viewModel)
                                }
                            case .finished(let viewModel):
                                NavigationLink(destination: {

                                }) {
                                    FinishedSessionCellView(viewModel: viewModel)
                                }
                            }
                        }
                        .listRowBackground(
                            cells[index].id == .live
                            ? Color.red.opacity(0.40).clipped().cornerRadius(7)
                            : nil
                        )
                    }
                }
            }
            .navigationTitle("Sessions")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
