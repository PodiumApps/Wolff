import SwiftUI

struct AppView<ViewModel: AppViewModelRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        switch viewModel.state {
        case .error(let string):
            Text(string)
        case .loading:
            ProgressView()
        case.results(let sessionViewModel):
            NavigationView {
                NavigationLink(
                    "Live view",
                    destination: SessionStandingsListView(viewModel: sessionViewModel)
                )
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(viewModel: AppViewModel.make())
    }
}
