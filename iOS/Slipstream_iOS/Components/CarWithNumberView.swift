import SwiftUI

struct CarWithNumberView: View {
    
    private let color: Color
    private let circleText: String
    
    init(color: Color, circleText: String) {
        
        self.color = color
        self.circleText = circleText
    }
    
    var body: some View {
        
        ZStack {
            Image.racingCar
                .resizable()
                .scaledToFill()
                .frame(width: Constants.Image.width, height: Constants.Image.height)
                .foregroundColor(color)
                .offset(y: Constants.RacingCar.imageYOffset)
            
            Text(circleText)
                .font(.Caption.regular)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.Spacing.default)
                .offset(x: Constants.RacingCar.textXOffset, y: Constants.RacingCar.textYOffset)
        }
    }
}

fileprivate enum Constants {
    
    static let height: CGFloat = 120
    static let cornerRadius: CGFloat = 16
    
    enum RacingCar {
        
        static let imageYOffset: CGFloat = 0
        
        static let textYOffset: CGFloat = 1
        static let textXOffset: CGFloat = -10
    }
    
    enum Image {
        
        static let height: CGFloat = 15
        static let width: CGFloat = 55
    }
}

struct CarWithNumberView_Previews: PreviewProvider {
    static var previews: some View {
        CarWithNumberView(color: .accentColor, circleText: "10")
    }
}
