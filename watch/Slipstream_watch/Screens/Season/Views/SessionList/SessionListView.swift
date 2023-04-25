import SwiftUI

struct SessionListView<ViewModel: SessionListViewModelRepresentable>: View {

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
            case .results(let cells, let trackInfoViewModel):
                List {
                    ForEach(0 ..< cells.count, id: \.self) { index in
                        Group {
                            switch cells[index] {
                            case .live(let viewModel):
                                LiveSessionCellView(viewModel: viewModel)
                            case .upcoming(let viewModel):
                                UpcomingSessionCellView(viewModel: viewModel)
                            case .finished(let viewModel):
                                FinishedSessionCellView(viewModel: viewModel)
                            }
                        }
                        .background(
                            cells[index].id == .live
                                ? Color.red
                                    .opacity(Constants.RowBackground.opacity)
                                    .clipped()
                                    .cornerRadius(Constants.RowBackground.cornerRadius)
                                : nil
                        )
                    }

                    TrackInfoCellView(viewModel: trackInfoViewModel)
                        .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }
        .navigationTitle(Localization.Session.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

fileprivate enum Constants {

    enum RowBackground {

        static let opacity: CGFloat = 0.40
        static let cornerRadius: CGFloat = 7
    }
}
