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
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(cells) { cell in
                            switch cell {
                            case .live(let viewModel, let index):
                                LiveView(viewModel: viewModel)
                                    .redacted(reason: index == nil ? .placeholder : [])
                                    .onTapGesture {
                                        if let index {
                                            self.viewModel.action.send(.tap(index: index))
                                        }
                                    }
                            case .upcoming(let events):
                                Text("Upcoming")
                                    .font(.system(size: 24, weight: .heavy))
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 16) {
                                        ForEach(0 ..< events.count, id: \.self) { index in
                                            GrandPrixCardView(viewModel: events[index]) {
                                                
                                            }
                                        }
                                    }
                                }
                                .frame(height: 100)
                                
                            case .pastEvent:
                                Text("Past Events")
                                    .font(.system(size: 24, weight: .heavy))
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 16)
                    .redacted(reason: viewModel.state.id == stateID.loading.rawValue ? .placeholder : [])
//                    ScrollView(showsIndicators: false) {
//                        ForEach(0 ..< events.count, id: \.self) { index in
//                            GrandPrixCardView(viewModel: events[index])
//                                .padding(.horizontal, 12)
//                                .redacted(
//                                    reason: viewModel.state.id == statedID.loading.rawValue ? .placeholder : []
//                                )
//                                .onTapGesture {
//                                    if viewModel.state.id != statedID.loading.rawValue {
//                                        viewModel.action.send(.tap(index: index))
//                                    }
//                                }
//                        }
//                    }
                }
            }
            .navigationDestination(for: SeasonListViewModel.Route.self) { route in
                switch route {
                case .sessionStandings(let viewModel):
                    SessionStandingsListView(viewModel: viewModel)
                }
            }
            .navigationBarTitle("Season 2023")
        }
    }
}

struct SeasonListView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonListView(viewModel: SeasonListViewModel.make())
    }
}
