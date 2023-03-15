import SwiftUI

struct StandingsCellView<ViewModel: StandingsCellViewModelRepresentable>: View {
    
    private var viewModel: ViewModel
    private let constructorStyler: ConstructorStylerRepresentable
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: viewModel.constructorStylerID)
    }
    var body: some View {
        HStack(spacing: 16) {
            Text("\(viewModel.position)")
                .font(.system(size: 24))
//            CarWithNumberView(color: constructorStyler.constructor.color, circleText: viewModel.circleText)
            DriverDetailsTextView(
                titleRegular: viewModel.titleRegular,
                titleBold: viewModel.titleBold,
                detailsText: viewModel.detailsText,
                color: constructorStyler.constructor.color
            )
            
            Spacer()
            
            Text("\(viewModel.points) pts")
                .font(.system(size: 18, weight: .semibold))
        }
    }
}


struct StandingsCellView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsCellView(viewModel: StandingsCellViewModel.mock)
    }
}
