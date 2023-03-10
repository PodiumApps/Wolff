import SwiftUI

struct SeasonListView<ViewModel: SeasonListViewModelRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    @State var xTranslate: CGFloat = -UIScreen.main.bounds.width / 2
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        NavigationStack(path: $viewModel.route) {
            Group {
                switch viewModel.state {
                case .error:
                    Text("Error")
                case .results(let events), .loading(let events):
                    ScrollView(showsIndicators: false) {
                        ForEach(0 ..< events.count, id: \.self) { index in
                            GrandPrixCardView(viewModel: events[index])
                                .padding(.bottom, 8)
                                .padding(.horizontal, 12)
                                .redacted(
                                    reason: viewModel.state.id == SeasonListViewModel.State.idValue.loading.rawValue
                                    ? .placeholder
                                    : []
                                )
                                .onTapGesture {
                                    viewModel.action.send(.tap(index: index))
                                }
                        }
                    }
                }
            }
            .navigationDestination(for: SeasonListViewModel.Route.self) { route in
                switch route {
                case .sessionStandings(let viewModel):
                    SessionStandingsListView(viewModel: viewModel)
                }
            }
            .navigationBarTitle("Season")
        }
    }
}

struct SeasonListView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonListView(viewModel: SeasonListViewModel.make())
    }
}
