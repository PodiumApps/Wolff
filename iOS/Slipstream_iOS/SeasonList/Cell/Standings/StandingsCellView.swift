import SwiftUI

struct StandingsCellView<ViewModel: StandingsCellViewModelRepresentable>: View {
    
    private var viewModel: ViewModel
    private let constructorStyler: ConstructorStylerRepresentable
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: viewModel.constructorStylerID)
    }
    var body: some View {
        HStack(spacing: .Spacing.default4) {
            Text("\(viewModel.position)")
                .font(.Title3.regular)
            DriverDetailsTextView(
                titleRegular: viewModel.titleRegular,
                titleBold: viewModel.titleBold,
                detailsText: viewModel.detailsText,
                color: constructorStyler.constructor.color
            )
            
            Spacer()
            
            Text("\(viewModel.points) pts")
                .font(.Body.semibold)
        }
    }
}


struct StandingsCellView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsCellView(viewModel: StandingsCellViewModel.mock)
    }
}
