import SwiftUI

struct AppView<ViewModel: AppViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        switch viewModel.state {
        case .error(let error):
            Text(error)
        case .loading:
            ProgressView()
        case .results:
            TabView {
                Text("Season")
                Text("Standings")
                Text("Settings")
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(viewModel: AppViewModel.make())
    }
}
