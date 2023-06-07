import SwiftUI

struct SeasonListView<ViewModel: SeasonListViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel
    @State private var listHasAlreadyScrolled = false

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        NavigationStack(path: $viewModel.route) {
            Group {
                switch viewModel.state {
                case .error(let error):
                    Text(error)
                case .results(let cells, let indexFirstToAppear):
                    ScrollViewReader { proxy in
                        List(0 ..< cells.count, id: \.self) { index in
                            switch cells[index] {
                            case .upcoming(let viewModel):
                                UpcomingEventCardView(viewModel: viewModel)
                                    .id(index)
                                    .padding(.vertical, .Spacing.default2)
                            case .live(let viewModel):
                                LiveEventCardView(viewModel: viewModel)
                                    .id(index)
                                    .padding(.vertical, .Spacing.default2)
                            case .finished(let viewModel):
                                FinishedEventCardView(viewModel: viewModel)
                                    .id(index)
                                    .padding(.vertical, .Spacing.default2)
                            case .calledOff(let viewModel):
                                CalledOffEventCardView(viewModel: viewModel)
                                    .id(index)
                                    .padding(.vertical, .Spacing.default2)
                            }
                        }
                        .listStyle(.carousel)
                        .onAppear {
                            if !listHasAlreadyScrolled {
                                withAnimation {
                                    proxy.scrollTo(indexFirstToAppear)
                                }
                                
                                listHasAlreadyScrolled = true
                            }
                        }
                    }
                case .loading:
                    ProgressView()
                }
            }
            .navigationTitle("Season")
            .navigationDestination(for: SeasonNavigation.Route.self) { route in
                switch route {
                case .sessionsList(let viewModel):
                    SessionListView(viewModel: viewModel)
                case .sessionStandingsList(let viewModel):
                    SessionStandingsListView(viewModel: viewModel)
                }
            }
        }
    }
}

fileprivate enum Constants {

    enum Card {

        static let verticalPadding: CGFloat = 7
    }
}
