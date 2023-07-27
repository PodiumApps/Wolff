import SwiftUI

struct SeasonListView<ViewModel: SeasonListViewModelRepresentable>: View {

    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject private var viewModel: ViewModel
    @State private var listHasAlreadyScrolled = false
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        Group {
            switch viewModel.state {
            case .results(let cells, let indexFirstToAppear):
                ScrollViewReader { proxy in
                    List(0 ..< cells.count, id: \.self) { index in
                        switch cells[index] {
                        case .upcoming(let viewModel):
                            UpcomingEventCardView(viewModel: viewModel)
                                .id(index)
                                .padding(.vertical, Constants.Card.verticalPadding)
                        case .live(let viewModel):
                            LiveEventCardView(viewModel: viewModel)
                                .id(index)
                                .padding(.vertical, Constants.Card.verticalPadding)
                        case .finished(let viewModel):
                            FinishedEventCardView(viewModel: viewModel)
                                .id(index)
                                .padding(.vertical, Constants.Card.verticalPadding)
                        case .calledOff(let viewModel):
                            CalledOffEventCardView(viewModel: viewModel)
                                .id(index)
                                .padding(.vertical, Constants.Card.verticalPadding)
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
        .navigationTitle(Localization.SeasonListView.Navigation.title)
        .onChange(of: scenePhase) { scenePhase in
            switch scenePhase {
            case .background:
                viewModel.action.send(.stopTimers)
            case .active:
                viewModel.action.send(.resumeTimers)
            default:
                return
            }
        }
    }
}

fileprivate enum Constants {
    
    enum Card {
        
        static let verticalPadding: CGFloat = 7
    }
}
