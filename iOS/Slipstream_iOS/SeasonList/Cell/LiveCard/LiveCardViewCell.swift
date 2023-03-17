import SwiftUI

struct LiveCardViewCell<ViewModel: LiveCardCellViewModelRepresentable>: View {
    
    @State private var startLiveAnimation: Bool = false
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                if viewModel.isLive {
                    LiveIndicatorComponent
                }
                
                Text(viewModel.isLive ? Localization.LiveCardCell.Title.now : Localization.LiveCardCell.Title.soon)
                    .font(.Title4.heavy)
                    .foregroundColor(Color.accentColor)
            }
            HStack {
                Text(viewModel.topSection.title)
                    .font(.Title4.bold)
                Spacer()
                Text(Localization.LiveCardCell.Top.round(viewModel.topSection.round))
                    .font(.Body.regular)
            }
            Button(action: {
                viewModel.action.send(())
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: .Spacing.default2) {
                        HStack(spacing: .Spacing.default6) {
                            Text(viewModel.cardSection.title)
                                .font(.Title4.heavy)
                            
                            if let status = viewModel.cardSection.status, viewModel.isLive {
                                Text(status)
                            }
                        }
                        
                        if viewModel.time.minutes > 0 {
                            TimeView
                        } else if !viewModel.cardSection.drivers.isEmpty {
                            DriversPositionsView
                        } else {
                            Text(Localization.LiveCardCell.aboutToStart)
                                .font(.Title4.heavy)
                        }
                    }
                    
                    Spacer()
                    
                    Image.chevronRight
                        .font(.Title.regular)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, .Spacing.default3)
            .padding(.vertical, .Spacing.default4)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                    .fill(Color.accentColor.gradient)
                    .opacity(Constants.Card.opacity)
                    .shadow(
                        radius: Constants.Card.shadowRadius,
                        x: Constants.Card.horizontalShadow,
                        y: Constants.Card.verticalShadow
                    )
            )
        }
    }
    
    private var TimeView: some View {
        
        HStack(alignment: .firstTextBaseline, spacing: .Spacing.default) {
            if viewModel.time.hours > 0 {
                Text("\(viewModel.time.hours)")
                    .font(.Title4.heavy)
                Text(Localization.LiveCardCell.Time.hours)
                    .font(.Caption.semibold)
            }
            
            Text("\(viewModel.time.minutes)")
                .font(.Title4.heavy)
            Text(Localization.LiveCardCell.Time.minutes)
                .font(.Caption.semibold)
        }
    }
    
    private var DriversPositionsView: some View {
        
        HStack(spacing: .Spacing.default3) {
            ForEach(0 ..< viewModel.cardSection.drivers.count, id: \.self) { index in
                HStack(alignment: .firstTextBaseline, spacing: .Spacing.default) {
                    Text("\(index + 1)")
                        .font(.Body.semibold)
                    + Text((index + 1).getPositionString)
                        .font(.Superscript.regular)
                        .fontWeight(.semibold)
                        .baselineOffset(Constants.DriverPosition.baselineOffset)
                        .foregroundColor(.white)
                    Text(viewModel.cardSection.drivers[index])
                        .font(.Title4.bold)
                }
            }
        }
    }
    
    private var LiveIndicatorComponent: some View {
        
        Circle()
            .frame(width: Constants.LiveComponent.circleSize)
            .scaleEffect(startLiveAnimation ? 1 : 0.2)
            .animation(
                .easeInOut(duration: Constants.LiveComponent.circleAnimationDuration).repeatForever(autoreverses: true),
                value: startLiveAnimation
            )
            .onAppear {
                startLiveAnimation.toggle()
            }
            .onDisappear {
                startLiveAnimation.toggle()
            }
            .foregroundColor(Color.accentColor)
    }
}

fileprivate enum Constants {
    
    enum DriverPosition {
        
        static let baselineOffset: CGFloat = 4.0
    }
    
    enum Card {
        
        static let horizontalShadow: CGFloat = 3
        static let verticalShadow: CGFloat = 3
        static let shadowRadius: CGFloat = 3
        static let cornerRadius: CGFloat = 12
        static let opacity: CGFloat = 0.9
    }
    
    enum LiveComponent {
        
        static let width: CGFloat = 78
        static let circleSize: CGFloat = 12
        static let circleAnimationDuration: Double = 1
        static let circleAnimationAmount: Double = 0.2
        static let circleAnimationDecrease: Double = 0.6
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForEach(ColorScheme.allCases, id: \.self) {
            LiveCardViewCell(viewModel: LiveCardCellViewModel.mockLiveAboutToStart)
                .preferredColorScheme($0)
        }
    }
}
