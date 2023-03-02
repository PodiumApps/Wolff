import SwiftUI

struct SessionStandingsListView<ViewModel: SessionStandingsListViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
    }

    var body: some View {
        
        Group {
            switch viewModel.state {
                
            case .error:
                Text("Error")
            case .loading:
                ProgressView()
            case .results(let rowsViewModel):
                
                List {
                    ForEach(0 ..< rowsViewModel.count, id: \.self) { index in
                        SessionDriverRowView(viewModel: rowsViewModel[index]) {
                            viewModel.action.send(.tap(index))
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            viewModel.action.send(.viewDidLoad)
        }
        .onDisappear {
            viewModel.action.send(.onDisappear)
        }
    }
}

//struct SessionStandingsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionStandingsListView(
//            viewModel: SessionStandingsListViewModel(
//                standings: [
//                    SessionDriverRowViewModel(
//                        position: "30",
//                        driverTicker: "HAM",
//                        timeGap: "-",
//                        tyrePitCount: "1",
//                        currentTyre: .intermediate
//                    ),
//                    SessionDriverRowViewModel(
//                        position: "2",
//                        driverTicker: "VER",
//                        timeGap: "+2.344",
//                        tyrePitCount: "3",
//                        currentTyre: .medium
//                    ),
//                    SessionDriverRowViewModel(
//                        position: "3",
//                        driverTicker: "RUS",
//                        timeGap: "+3.531",
//                        tyrePitCount: "2",
//                        currentTyre: .hard
//                    ),
//                    SessionDriverRowViewModel(
//                        position: "4",
//                        driverTicker: "LEC",
//                        timeGap: "+3.562",
//                        tyrePitCount: "3",
//                        currentTyre: .medium
//                    ),
//                    SessionDriverRowViewModel(
//                        position: "5",
//                        driverTicker: "SAI",
//                        timeGap: "+4.143",
//                        tyrePitCount: "4",
//                        currentTyre: .hard
//                    )
//                ]
//            )
//        )
//    }
//}
