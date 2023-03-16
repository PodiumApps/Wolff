import SwiftUI

struct SeasonListView<ViewModel: SeasonListViewModelRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    private typealias stateID = SeasonListViewModel.State.idValue
    
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
                case .results(let cells), .loading(let cells):
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(cells) { cell in
                            switch cell {
                            case .live(let viewModel, let isLoading):
                                
                                LiveCardViewCell(viewModel: viewModel)
                                    .foregroundColor(.primary)
                                    .redacted(reason: isLoading ? .placeholder : [])
                                    .padding(.horizontal, 12)
                                
                                Divider()
                                    .padding(.horizontal, 12)
                                    .padding(.top, 16)
                                
                            case .upcomingAndStandings(let viewModel):
                                ScrollView {
                                    UpcomingAndStandingsEventCellView(viewModel: viewModel)
                                        .padding(.top, 16)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 16)
                    .redacted(reason: viewModel.state.id == stateID.loading.rawValue ? .placeholder : [])
                }
            }
            .navigationDestination(for: SeasonListViewModel.Route.self) { route in
                switch route {
                case .sessionStandings(let viewModel):
                    SessionStandingsListView(viewModel: viewModel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Season 2023")
        }
    }
}

struct SeasonListView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonListView(viewModel: SeasonListViewModel.make())
    }
}
