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
                            case .live(let viewModel, let index):
                                
                                LiveCardViewCell(viewModel: viewModel) {
                                    if let index {
                                        self.viewModel.action.send(.tap(index: index))
                                    }
                                }
                                .foregroundColor(.primary)
                                .redacted(reason: index == nil ? .placeholder : [])
                                .padding(.horizontal, 12)
                                
                                Divider()
                                    .padding(.horizontal, 12)
                                    .padding(.top, 16)
                                
                            case .upcomingAndStandings(let viewModel):
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            ForEach(self.viewModel.filters) { filter in
                                                Button(action: {
                                                    self.viewModel.action.send(.filterEvent(filter))
                                                }) {
                                                    Text(filter.label)
                                                        .font(.system(size: 24, weight: .semibold))
                                                        .foregroundColor(
                                                            filter == self.viewModel.upcomingOrPastSelection
                                                            ? .accentColor
                                                            : Color(UIColor.systemGray4)
                                                        )
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        UpcomingAndStandingsEventCellView(viewModel: viewModel)
                                            .padding(.horizontal, 12)
                                    }
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
