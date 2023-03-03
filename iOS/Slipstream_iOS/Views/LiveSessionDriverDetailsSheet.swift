import SwiftUI

struct LiveSessionDriverDetailsSheet<ViewModel: LiveSessionDriverDetailsSheetViewModelRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    private let constructorStyler: ConstructorStylerRepresentable
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: viewModel.constructor.constructorId)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(constructorStyler.constructor.color.gradient)
                .opacity(0.05)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.driver.fullName)
                            .font(.driverPositionFont)
                            .fontWeight(.semibold)
                        HStack {
                            Text(viewModel.constructor.name)
                                .fontWeight(.thin)
                        }
                    }
                    Spacer()
                    ZStack {
                        Image.racingCar
                            .resizable()
                            .scaledToFill()
                            .frame(width: Constants.Image.width, height: Constants.Image.height)
                            .foregroundColor(constructorStyler.constructor.color)
                            .offset(y: 10)
                        
                        Text("\(viewModel.driver.carNumber)")
                            .font(.footnote)
                            .foregroundColor(constructorStyler.constructor.color)
                            .padding(4)
                            .background(
                                Circle()
                                    .fill(.white)
                            )
                            .offset(x: -33, y: 2)
                    }
                }
                
                Divider()
                
                // TODO: - idea for the bottom part of the bottom sheet
//                HStack {
//                    Text("Provisional Standings")
//                        .font(.eventTitleFont)
//                        .fontWeight(.medium)
//                    Text("1")
//                        .font(.liveTextFont)
//                        .fontWeight(.light)
//                    Image(systemName: "arrow.up.circle.fill")
//                        .foregroundColor(.green)
//
//                    Spacer()
//
//                }
                
                
                Spacer()
            }
            .padding()
        }
        .frame(height: Constants.height)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

fileprivate enum Constants {
    
    static let height: CGFloat = 200
    static let cornerRadius: CGFloat = 16
    
    enum Image {
        
        static let height: CGFloat = 15
        static let width: CGFloat = 55
    }
}

struct LiveSessionDriverDetailsSheet_Previews: PreviewProvider {
    static var previews: some View {
        LiveSessionDriverDetailsSheet(
            viewModel: LiveSessionDriverDetailsSheetViewModel(
                driver: Driver.mockVertasppen,
                constructor: Constructor.mockFerrari
            )
        )
    }
}
