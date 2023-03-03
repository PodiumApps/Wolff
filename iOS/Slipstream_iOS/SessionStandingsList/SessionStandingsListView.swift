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
                Text(Localization.SessionDriverList.Error.text)
                Button(Localization.SessionDriverList.Error.cta) { viewModel.action.send(.refresh) }
            case .loading:
                ProgressView()
            case .results(let rowsViewModel):
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
                            if let selectedDriverViewModel = viewModel.selectedDriver {
                            Spacer()
                            LiveSessionDriverDetailsSheet(viewModel: selectedDriverViewModel)
                        }
                    }
                    .ignoresSafeArea(.all)
                )
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

fileprivate enum Constants {
    
    enum ScrollView {
        
        static let paddingHorizontal: CGFloat = 4
    }
    
    enum RowView {
        
        static let paddingBottom: CGFloat = 200
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
