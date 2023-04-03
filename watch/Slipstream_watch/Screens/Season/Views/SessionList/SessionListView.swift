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
                        NavigationLink(destination: EmptyView()) {
                            switch cells[index] {
                            case .live(let viewModel):
                                LiveSessionCellView(viewModel: viewModel)
                            case .upcoming(let viewModel):
                                UpcomingSessionView(viewModel: viewModel)
                            case .finished(let viewModel):
                                FinishedSessionCellView(viewModel: viewModel)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sessions")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct SessionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionListView(viewModel: <#_#>)
//    }
//}
