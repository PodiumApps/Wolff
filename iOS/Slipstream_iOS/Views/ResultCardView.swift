import SwiftUI

struct ResultCardView<ViewModel: ResultCardRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        VStack {
            VStack(alignment: .leading, spacing: Constants.topInfoSpacing) {
                HStack {
                    Text(viewModel.sessionType.label)
                        .font(.titleFontBold)
                    Spacer()
                    Image.informationIcon
                        .foregroundColor(Color.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                }

                HStack {
                    Image.iconFastestLap
                    Text(viewModel.fastestLap)
                }
                .font(.subheadlineFont)
            }
            .padding(Constants.topInfoPadding)
            .foregroundColor(Constants.topInfoColor)
            
            ZStack {
                ForEach(viewModel.drivers) {
                    driverCircle(
                        position: $0.value,
                        driverTicker: $0.id
                    )
                }
            }
            .offset(y: Constants.combinedDriverCirclesYOffset)
            
            Spacer()
        }
        .background(
            Image.resultsCardBackground
                .resizable()
                .scaledToFill()
                .frame(width: Constants.cardSquareSize, height: Constants.cardSquareSize)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                        .background(Color.black)
                        .opacity(Constants.backgroundImageOpacity)
                )
        )
        .frame(width: Constants.cardSquareSize, height: Constants.cardSquareSize)
        .cornerRadius(Constants.cardCornerRadius)
        .shadow(
            radius: Constants.cardShadowRadius,
            x: Constants.cardShadowXPosition,
            y: Constants.cardShadowYPosition
        )
    }

    func driverCircle(position: DriverResult.Value, driverTicker: String) -> some View {

        VStack {
            if position.showTrophyImage {
                Image.trophyIcon
            } else {
                Text(position.label)
                    .font(.driverPositionFont)
            }

            Text(driverTicker)
                .font(.driverTickerFont)
        }
        .frame(width: Constants.driverCircleDiameter, height: Constants.driverCircleDiameter)
        .background(applyCircleBackgroundColor(position: position))
        .overlay(
            Circle()
                .stroke(Color.white.gradient, lineWidth: Constants.driverCircleBorderLinewidth)
                .opacity(0.8)
        )
        .clipShape(Circle())
        .offset(x: applyXOffset(position: position), y: applyYOffset(position: position))
    }

    func applyCircleBackgroundColor(position: DriverResult.Value) -> AnyGradient {

        switch position {
        case .first: return Color.yellow.gradient
        case .second: return Color.gray.gradient
        case .third: return Color.brown.gradient
        }
    }

    func applyXOffset(position: DriverResult.Value) -> CGFloat {

        switch position {
        case .second: return Constants.secondPositionCircleXOffset
        case .third: return Constants.thirdPositionCircleXOffset
        default: return CGFloat(0)
        }
    }

    func applyYOffset(position: DriverResult.Value)-> CGFloat {

        switch position {
        case .first: return Constants.firstPositionCircleYOffset
        case .second: return Constants.secondPositionCircleYOffset
        case .third: return Constants.thirdPositionCircleYOffset
        }
    }
}

fileprivate enum Constants {

    static let cardSquareSize: CGFloat = 170
    static let cardCornerRadius: CGFloat = 10
    static let cardShadowRadius: CGFloat = 7
    static let cardShadowXPosition: CGFloat = 5
    static let cardShadowYPosition: CGFloat = 7

    static let backgroundImageOpacity: Double = 0.1

    static let topInfoPadding: CGFloat = 10
    static let topInfoColor: Color = Color.white
    static let topInfoSpacing: CGFloat = 3

    static let driverCircleDiameter: CGFloat = 62
    static let driverCircleBorderLinewidth: CGFloat = 3

    static let firstPositionCircleYOffset: CGFloat = -25

    static let secondPositionCircleXOffset: CGFloat = -42
    static let secondPositionCircleYOffset: CGFloat = 5

    static let thirdPositionCircleXOffset: CGFloat = 42
    static let thirdPositionCircleYOffset: CGFloat = 5

    static let combinedDriverCirclesYOffset: CGFloat = 17
}

struct ResultCard_Previews: PreviewProvider {

    static var previews: some View {
        ResultCardView(
            viewModel:
                ResultCardViewModel(
                    sessionType: Session.mockSession.name,
                    fastestLap: "1:20:507",
                    drivers: [
                        .init(driverTicker: Driver.mockHamilton.codeName, value: .first),
                        .init(driverTicker: Driver.mockVertasppen.codeName, value: .second),
                        .init(driverTicker: Driver.mockLeclerc.codeName, value: .third)
                    ]
                )
        )
    }
}
