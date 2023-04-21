import SwiftUI

struct SessionStandingsListView<ViewModel: SessionStandingsListViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(0 ..< viewModel.cells.count, id: \.self) { index in
            DriverStandingCellView(viewModel: viewModel.cells[index])
        }
    }
}

//struct LiveSessionStandingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionStandingsView()
//    }
//}
