import SwiftUI

struct UpcomingAndStandingsEventCellView<ViewModel: UpcomingAndStandingsEventCellViewModelRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ForEach(viewModel.cells) { cell in
                
                switch cell {
                case .upcoming(let cardsVM):
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(0 ..< cardsVM.count, id: \.self) { index in
                                GrandPrixCardView(viewModel: cardsVM[index]) {
                                    
                                }
                                .padding(.leading, index == 0 ? 12 : 0)
                                .padding(.trailing, index == cardsVM.count - 1 ? 12 : 0)
                            }
                        }
                    }
                    .frame(height: 120)
                    Divider()
                case .standings(let drivers, let constructors):
                    Text("Current Standings")
                        .font(.system(size: 24, weight: .heavy))
                        .padding(.horizontal, 12)
                    
                    ForEach(drivers) { driver in
                        StandingsCellView(viewModel: StandingsCellViewModel(driver: driver, constructor: constructors))
                            .padding(.top, 8)
                        Divider()
                        
                    }
                    .padding(.horizontal, 12)
                    .listStyle(.plain)
                }
            }
        }
    }
}

//struct UpcomingAndPastEventCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpcomingAndPastEventCellView(
//            viewModel: UpcomingAndPastEventCellViewModel(
//                upcoming: GrandPrixCardViewModel.mockArray,
//                finished: GrandPrixCardViewModel.mockArray
//            )
//        )
//    }
//}
