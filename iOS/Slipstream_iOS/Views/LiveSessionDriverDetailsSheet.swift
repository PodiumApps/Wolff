import SwiftUI

struct LiveSessionDriverDetailsSheet<ViewModel: LiveSessionDriverDetailsSheetViewModelRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    private let constructorStyler: ConstructorStylerRepresentable
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: viewModel.constructorStylerID)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.Background.cornerRadius)
                .fill(constructorStyler.constructor.color.gradient)
                .opacity(Constants.Background.opacity)
                .frame(height: Constants.height)
            
            VStack(alignment: .leading, spacing: Constants.Spacing.parentVerticalStack) {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: Constants.Spacing.horizontalStacks) {
                        HStack(alignment: .bottom, spacing: Constants.Spacing.horizontalStacks) {
                            Text(viewModel.titleRegular)
                                .fontWeight(.regular)
                            Text(viewModel.titleBold)
                                .foregroundColor(constructorStyler.constructor.color)
                                .font(.driverPositionFont)
                                .fontWeight(.semibold)
                        }
                        Text(viewModel.detailsText)
                            .fontWeight(.thin)
                    }
                    Spacer()
                    ZStack {
                        Image.racingCar
                            .resizable()
                            .scaledToFill()
                            .frame(width: Constants.Image.width, height: Constants.Image.height)
                            .foregroundColor(constructorStyler.constructor.color)
                            .offset(y: Constants.RacingCar.imageYOffset)
                        
                        Text(viewModel.circleText)
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(Constants.RacingCar.textPadding)
//                            .background(
//                                Circle()
//                                    .fill(constructorStyler.constructor.color)
//                                    .frame(width: 25)
//                            )
                            .offset(x: Constants.RacingCar.textXOffset, y: Constants.RacingCar.textYOffset)
                    }
                }
                
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
    
    static let height: CGFloat = 120
    static let cornerRadius: CGFloat = 16
    
    enum Spacing {
        
        static let parentVerticalStack: CGFloat = 10
        static let horizontalStacks: CGFloat = 4
    }
    
    enum Background {
        
        static let cornerRadius: CGFloat = 16
        static let opacity: CGFloat = 0.05
    }
    
    enum RacingCar {
        
        static let imageYOffset: CGFloat = 0
        
        static let textPadding: CGFloat = 4
        static let textYOffset: CGFloat = 1
        static let textXOffset: CGFloat = -10
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
