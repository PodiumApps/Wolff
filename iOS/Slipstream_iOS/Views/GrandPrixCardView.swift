import SwiftUI

struct GrandPrixCardView<ViewModel: GrandPrixCardViewModelRepresentable>: View {
    
    @State private var liveCircleAnimationAmount = Constants.LiveComponent.circleAnimationAmount
    
    private let viewModel: ViewModel
    private var eventStatusBackgroundStyler: EventStatusBackgroundStyler
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
        self.eventStatusBackgroundStyler = EventStatusBackgroundStyler(grandPrixCardStatus: viewModel.eventStatus)
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(Localization.GrandPrixCard.Top.round(viewModel.round))
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                    Divider()
//                    Text("11-13 Oct")
//                        .font(.system(size: 15))
//                        .foregroundColor(.white)
//                    Rectangle()
//                        .fill(Color.white)
//                        .frame(width: 1, height: 10)
                    
                    Text("1: HAM")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("2: HAM")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("3: HAM")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                    .foregroundColor(.white)
                }
                
                
                
                VStack(alignment: .leading) {
                    Text("Emilia-Romagna, Italy")
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical)
            .padding(.leading, 8)
            .padding(.trailing, 4)
            Spacer()
            
            switch viewModel.eventStatus {
            case .live(_, _, let sessions) where !sessions.isEmpty:
                liveIndicatorComponent()
                    .offset(x: -2)
            case .finished, .upcoming, .live:
                Image.chevronRight
                    .font(.chevronRightFont)
                    .foregroundColor(.white)
                    .padding(.trailing, Constants.Card.contentPadding)
            }
            
        }
        .frame(height: Constants.Card.height)
        .background(
            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                .fill(Color.accentColor.gradient)
                .shadow(
                    radius: Constants.Card.shadowRadius,
                    x: Constants.Card.horizontalShadow,
                    y: Constants.Card.verticalShadow
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: Constants.Card.cornerRadius))
        
        // Color.accentColor.gradient - live event
        // Color(UIColor.systemGray) - finished
        
        
        //        ZStack {
        //            HStack {
        //                VStack(alignment: .leading, spacing: Constants.Card.verticalSpacing) {
        //                    HStack(alignment: .top) {
        //                        Circle()
        //                            .strokeBorder()
        //                            .overlay(
        //                                Text(Localization.GrandPrixCard.Top.round(viewModel.round))
        //                                    .foregroundColor(.white)
        //                                    .fontWeight(.bold)
        //                            )
        //                            .background(Color.red)
        //                            .clipShape(Circle())
        //                            .frame(width: 40, height: 40)
        //                        Text(viewModel.title.uppercased())
        //                            .minimumScaleFactor(Constants.Card.titleTextScalingFactor)
        //                            .font(.eventTitleFont)
        //                        Text(Localization.GrandPrixCard.Top.round(viewModel.round))
        //                            .font(.eventRoundNumberFont)
        //
        //                        Spacer()
        //                    }
        //
        //                    EventComponentView(eventStatus: viewModel.eventStatus)
        //                }
        //                .frame(maxWidth: .infinity)
        //                .padding(Constants.Card.contentPadding)
        //
        //                Spacer()
        //
        //                switch viewModel.eventStatus {
        //                case .finished, .upcoming:
        //                    Image.chevronRight
        //                        .font(.chevronRightFont)
        //                        .padding(.trailing, Constants.Card.contentPadding)
        //                case .live:
        //                    liveIndicatorComponent()
        //                }
        //            }
        //            .frame(height: Constants.Card.height)
        //            .background(
        //                RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
        //                    .fill(eventStatusBackgroundStyler.color.gradient)
        //                    .shadow(
        //                        radius: Constants.Card.shadowRadius,
        //                        x: Constants.Card.horizontalShadow,
        //                        y: Constants.Card.verticalShadow
        //                    )
        //            )
        //            .clipShape(RoundedRectangle(cornerRadius: Constants.Card.cornerRadius))
        //        }
        .frame(height: Constants.Card.height)
    }
    
    func liveIndicatorComponent() -> some View {
        
        HStack {
            Circle()
                .frame(width: Constants.LiveComponent.circleSize)
                .scaleEffect(liveCircleAnimationAmount)
                .animation(
                    .easeInOut(
                        duration: Constants.LiveComponent.circleAnimationDuration).repeatForever(autoreverses: true),
                    value: liveCircleAnimationAmount
                )
                .onAppear {
                    liveCircleAnimationAmount = 0
                }
            
            Text(Localization.GrandPrixCard.Label.live)
                .font(.liveTextFont)
        }
        .frame(width: Constants.LiveComponent.width, height: Constants.Card.height - 2)
        .foregroundColor(.red)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
    }
    
    func applyForegroundColor(position: DriverResult.Value) -> Color {
        
        switch position {
        case .first: return .yellow
        case .second: return .gray
        case .third: return .brown
        }
    }
}

fileprivate enum Constants {
    
    enum Card {
        
        static let width: CGFloat = UIScreen.main.bounds.width * 0.95
        static let height: CGFloat = 80
        static let cornerRadius: CGFloat = 10
        static let contentPadding: CGFloat = 12
        static let horizontalShadow: CGFloat = 3
        static let verticalShadow: CGFloat = 3
        static let verticalSpacing: CGFloat = 7
        static let shadowRadius: CGFloat = 3
        static let titleTextScalingFactor: CGFloat = 0.75
    }
    
    enum LiveComponent {
        
        static let width: CGFloat = 78
        static let circleSize: CGFloat = 12
        static let circleAnimationDuration: Double = 1
        static let circleAnimationAmount: Double = 1
        static let circleAnimationDecrease: Double = 0.6
    }
}

struct GrandPrixCardView_Previews: PreviewProvider {
    static var previews: some View {
        
        GrandPrixCardView(viewModel: GrandPrixCardViewModel.mockUpcoming)
            .previewDisplayName("Upcoming")
        
        GrandPrixCardView(viewModel: GrandPrixCardViewModel.mockNextSession)
            .previewDisplayName("Next Session")
        
        GrandPrixCardView(viewModel: GrandPrixCardViewModel.mockLive)
            .previewDisplayName("Live <8hours")
        
        GrandPrixCardView(viewModel: GrandPrixCardViewModel.mockFinished)
            .previewDisplayName("Finished")
        
        GrandPrixCardView(viewModel: GrandPrixCardViewModel.mockLiveEvent)
            .previewDisplayName("Live")
    }
}
