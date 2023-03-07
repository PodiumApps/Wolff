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
            RoundedRectangle(cornerRadius: Constants.Background.cornerRadius)
                .fill(constructorStyler.constructor.color.gradient)
                .opacity(Constants.Background.opacity)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.driver.firstName)
                            .font(.driverPositionFont)
                            .fontWeight(.regular)
                        HStack(spacing: 4) {
                            Text(viewModel.driver.lastName)
                                .font(.driverPositionFont)
                                .fontWeight(.semibold)
                                .foregroundColor(constructorStyler.constructor.color)
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
                            .offset(y: Constants.RacingCar.imageYOffset)
                        
                        Text("\(viewModel.driver.carNumber)")
                            .font(.footnote)
                            .foregroundColor(constructorStyler.constructor.color)
                            .padding(Constants.RacingCar.textPadding)
                            .background(
                                Circle()
                                    .fill(.white)
                            )
                            .offset(x: Constants.RacingCar.textXOffset, y: Constants.RacingCar.textYOffset)
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
    
    enum Background {
        
        static let cornerRadius: CGFloat = 16
        static let opacity: CGFloat = 0.05
    }
    
    enum RacingCar {
        
        static let imageYOffset: CGFloat = 10
        
        static let textPadding: CGFloat = 4
        static let textYOffset: CGFloat = 2
        static let textXOffset: CGFloat = -33
    }
    
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
