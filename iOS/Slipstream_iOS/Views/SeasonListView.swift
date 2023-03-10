import SwiftUI

struct SeasonListView<ViewModel: SeasonListViewModelRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .error:
            Text("Error")
        case .results(let events):
            
            ScrollView(showsIndicators: false) {
                ForEach(0 ..< events.count, id: \.self) { index in
                    GrandPrixCardView(viewModel: events[index])
                        .padding(.top, 4)
                        .padding(.horizontal, 6)
                }
            }
        }
    }
}

struct SeasonListView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonListView(viewModel: SeasonListViewModel.make(
            drivers: [.mockHamilton, .mockAlonso],
            constructors: [.mockMercedes, .mockAlfa])
        )
    }
}
