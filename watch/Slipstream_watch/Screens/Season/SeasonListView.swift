import SwiftUI

struct SeasonListView<ViewModel: SeasonListViewModelRepresentable>: View {

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
                case .results(let cells):
                    List(cells) { cell in
                        NavigationLink(destination: EmptyView()) {
                            switch cell {
                            case .upcoming(let viewModel):
                                UpcomingEventCardView(viewModel: viewModel)
                                    .frame(minHeight: 85)
                            case .live(let viewModel):
                                LiveEventCardView(viewModel: viewModel)
                                    .frame(minHeight: 85)
                            case .finished(let viewModel):
                                FinishedEventCardView(viewModel: viewModel)
                                    .frame(minHeight: 95)
                            }
                        }
                    }
                    .listStyle(.carousel)
                case .loading:
                    ProgressView()
                }
            }
            .navigationTitle("Season")
        }
    }
}

//struct SeasonListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeasonListView()
//    }
//}
