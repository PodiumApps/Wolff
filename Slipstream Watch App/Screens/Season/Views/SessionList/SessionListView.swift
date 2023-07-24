import SwiftUI

struct SessionListView<ViewModel: SessionListViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    private var listRowBackground: some View {
        Color.red
            .opacity(Constants.RowBackground.opacity)
            .clipped()
            .cornerRadius(Constants.RowBackground.cornerRadius)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .error(let error):
                Text(error)
            case .loading:
                ProgressView()
            case .results(let sections):
                List {
                    ForEach(0 ..< sections.count, id: \.self) { sectionIndex in
                        switch sections[sectionIndex] {
                        case .header(let trackInfoViewModel):
                            Section {
                                TrackInfoCellView(viewModel: trackInfoViewModel)
                            }
                        case .cells(let cells):
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
                                .listRowBackground(
                                    cells[index].id == .live ? listRowBackground : nil
                                )
                            }
                        }
                    }
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
