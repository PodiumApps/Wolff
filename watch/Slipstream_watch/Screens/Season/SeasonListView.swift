import SwiftUI

struct SeasonListView<ViewModel: SeasonListViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel
    
    @State private var animateOpacity = false

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        NavigationView {
            Group {
                switch viewModel.state {
                case .error(let error):
                    Text(error)
                case .results(let cells):
                    ScrollViewReader { proxy in
                        List(0 ..< cells.count, id: \.self) { index in
                            switch cells[index] {
                            case .upcoming(let viewModel):
                                UpcomingEventCardView(viewModel: viewModel)
                                    .id(index)
                                    .padding(.vertical, 7)
                            case .live(let viewModel):
                                LiveEventCardView(viewModel: viewModel)
                                    .id(index)
                                    .padding(.vertical, 7)
                            case .finished(let viewModel):
                                FinishedEventCardView(viewModel: viewModel)
                                    .id(index)
                                    .padding(.vertical, 7)
                            }
                        }
                        .listStyle(.carousel)
                        .onAppear {
                            withAnimation {
                                proxy.scrollTo(viewModel.indexFirstToAppear)
                            }
                        }
                    }
                case .loading:
                    ProgressView()
                }
            }
            .navigationTitle("Season")
        }
    }
}
