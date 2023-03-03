import SwiftUI

struct NewsCarouselComponentView<ViewModel: NewsCarouselComponentRepresentable>: View {

    private let viewModel: ViewModel
    private let constructorStyler: ConstructorStylerRepresentable

    init(viewModel: ViewModel, constructorID: String) {
        
        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: constructorID)
    }

    var body: some View {
        HStack {

            Text(viewModel.position.description)
                .font(.newsCarouselPositionFont)
                .foregroundColor(constructorStyler.constructor.color)

            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.driverName)
                        .font(.newsCarouselDriverNameFont)
                    Text("\(viewModel.points) pts")
                }

                Text(viewModel.constructorName)
                    .font(.newsCarouselConstrutorNameFont)
            }
        }
        .frame(height: Constants.height)
        .padding([.leading, .trailing], Constants.horizontalPadding)
    }
}

fileprivate enum Constants {

    static let height: CGFloat = 40
    static let horizontalPadding: CGFloat = 5
}



struct NewsCarouselComponentView_Previews: PreviewProvider {
    static var previews: some View {
        NewsCarouselComponentView(
            viewModel: NewsCarouselComponentViewModel(
                driverName: Driver.mockHamilton.fullName,
                constructorName: "Mercedes",
                position: 1,
                points: 100
            ),
            constructorID: "mercedes"
        )
    }
}
