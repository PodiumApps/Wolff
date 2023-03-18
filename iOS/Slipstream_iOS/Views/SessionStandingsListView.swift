import SwiftUI

struct SessionStandingsListView<ViewModel: SessionStandingsListViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
    }

    var body: some View {
        
        Group {
            switch viewModel.state {
                
            case .error(let error):
                Text(Localization.SessionDriverList.Error.text + " - \(error)")
                Button(Localization.SessionDriverList.Error.cta) { viewModel.action.send(.refresh) }
            case .results(let cells), .loading(let cells):
                
                VStack {
                    ForEach(cells) { cell in
                        switch cell {
                        case .header(let title):
                            Text(title)
                        case .positionList(let rowsViewModel):
                            ScrollView(showsIndicators: false) {
                                ForEach(0 ..< rowsViewModel.count, id: \.self) { index in
                                    SessionDriverRowView(viewModel: rowsViewModel[index]) {
                                        viewModel.action.send(.tap(index))
                                    }
                                    .padding(.bottom, index == rowsViewModel.count - 1 ? Constants.RowView.paddingBottom : 0)
                                }
                            }
                            .padding(.top, 150) // TODO: - Remove when we finish the top view
                            .padding(.horizontal, Constants.ScrollView.paddingHorizontal)
                            .overlay (
                                VStack {
                                    Spacer()
                                    LiveSessionDriverDetailsSheet(viewModel: viewModel.selectedDriver)
                                }
                                    .ignoresSafeArea(.all)
                            )
                        }
                    }
                }
                .redacted(reason: viewModel.state.id == .loading ? .placeholder : [])
            }
        }
        .onAppear {
            viewModel.action.send(.viewDidLoad)
        }
        .onDisappear {
            viewModel.action.send(.onDisappear)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

fileprivate enum Constants {
    
    enum ScrollView {
        
        static let paddingHorizontal: CGFloat = 4
    }
    
    enum RowView {
        
        static let paddingBottom: CGFloat = 200
    }
}

struct SessionStandingsListView_Previews: PreviewProvider {
    static var previews: some View {
        SessionStandingsListView(
            viewModel: SessionStandingsListViewModel.make(event: .mock)
        )
    }
}
