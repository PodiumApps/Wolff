import SwiftUI

struct SeasonListView<ViewModel: SeasonListViewModelRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
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
                                    .padding(.horizontal, .Spacing.default3)
                                
                                Divider()
                                    .padding(.horizontal, .Spacing.default3)
                                    .padding(.top, .Spacing.default4)
                                
                            case .upcomingAndStandings(let viewModel):
                                ScrollView {
                                    UpcomingAndStandingsEventCellView(viewModel: viewModel)
                                        .padding(.top, .Spacing.default4)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, .Spacing.default4)
                    .redacted(reason: viewModel.state.id == .loading ? .placeholder : [])
                }
            }
            .navigationDestination(for: SeasonListViewModel.Route.self) { route in
                switch route {
                case .sessionStandings(let viewModel):
                    SessionStandingsListView(viewModel: viewModel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(Localization.SeasonListView.Navigation.title)
        }
    }
}

struct SeasonListView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonListView(viewModel: SeasonListViewModel.make())
    }
}
