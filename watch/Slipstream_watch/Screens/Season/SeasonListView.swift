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
//                            Group {
                                switch cells[index] {
                                case .upcoming(let viewModel, let sessionListViewModel):
                                    NavigationLink(destination: {
                                        SessionListView(viewModel: sessionListViewModel)
                                    }) {
                                        UpcomingEventCardView(viewModel: viewModel)
                                            .id(index)
                                            .padding(.vertical, 7)
                                    }
                                case .live(let viewModel, let sessionListViewModel):
                                    LiveEventCardView(viewModel: viewModel)
                                        .id(index)
                                        .padding(.vertical, 7)
//                                    NavigationLink(destination: {
//                                        SessionListView(viewModel: sessionListViewModel)
//                                    }) {
//                                        LiveEventCardView(viewModel: viewModel)
//                                            .id(index)
//                                            .padding(.vertical, 7)
//                                    }
//                                    .listRowBackground(Color.red)
                                case .finished(let viewModel, let sessionListViewModel):
                                    NavigationLink(destination: {
                                        SessionListView(viewModel: sessionListViewModel)
                                    }) {
                                        FinishedEventCardView(viewModel: viewModel)
                                            .id(index)
                                            .padding(.vertical, 7)
                                    }
                                }
//                            }
//                            .listRowBackground(Color.clear)
//                            .listRowBackground(
//                                cells[index].id == .live
//                                ? Color.red.opacity(animateOpacity ? 0.25 : 0.40).clipped().cornerRadius(15)
//                                : Color.Event.completedOrUpcomingEvent.opacity(0.4).clipped().cornerRadius(15)
//                            )
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

//struct SeasonListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeasonListView()
//    }
//}
