import SwiftUI

struct LiveView<ViewModel: LiveViewModelRepresentable>: View {
    
    @State private var liveCircleAnimationAmount = Constants.LiveComponent.circleAnimationAmount
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                if viewModel.isLive {
                    liveIndicatorComponent()
                }
                
                Text("HAPPENING \(viewModel.isLive ? "NOW" : "SOON")")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(Color.accentColor)
            }
            HStack {
                Text(viewModel.topSection.title)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Text("Round \(viewModel.topSection.round)")
                    .font(.system(size: 16))
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 24) {
                        Text(viewModel.cardSection.title)
                            .font(.system(size: 20, weight: .heavy))
                        
                        if let status = viewModel.cardSection.status, viewModel.isLive {
                            Text(status)
                        }
                    }
                    
                    if viewModel.time.minutes > 0 {
                        HStack(alignment: .firstTextBaseline, spacing: 5) {
                            if viewModel.time.hours > 0 {
                                Text("\(viewModel.time.hours)")
                                    .font(.system(size: 20, weight: .heavy))
                                Text("HOUR")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            
                            Text("\(viewModel.time.minutes)")
                                .font(.system(size: 20, weight: .heavy))
                            Text("MINUTES left")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    } else if !viewModel.cardSection.drivers.isEmpty {
                        
                        HStack(spacing: 12) {
                            ForEach(0 ..< viewModel.cardSection.drivers.count, id: \.self) { index in
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                    Text("\(index + 1)")
                                        .font(.system(size: 16, weight: .semibold))
                                    + Text("º")
                                        .font(.system(size: 10))
                                        .fontWeight(.semibold)
                                        .baselineOffset(4.0)
                                        .foregroundColor(.white)
                                    Text(viewModel.cardSection.drivers[index])
                                        .font(.system(size: 20, weight: .bold))
                                }
                            }
                        }
                    } else {
                        Text("About to start")
                            .font(.system(size: 20, weight: .heavy))
                    }
                }
                
                Spacer()
                
                Image.chevronRight
                    .font(.system(size: 32))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.accentColor.gradient)
                    .opacity(0.9)
                    .shadow(
                        radius: Constants.Card.shadowRadius,
                        x: Constants.Card.horizontalShadow,
                        y: Constants.Card.verticalShadow
                    )
            )
        }
    }
    
    private func liveIndicatorComponent() -> some View {
        
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
            .foregroundColor(Color.accentColor)
    }
}

fileprivate enum Constants {
    
    enum Card {
        
        static let horizontalShadow: CGFloat = 3
        static let verticalShadow: CGFloat = 3
        static let shadowRadius: CGFloat = 3
    }
    
    enum LiveComponent {
        
        static let width: CGFloat = 78
        static let circleSize: CGFloat = 12
        static let circleAnimationDuration: Double = 1
        static let circleAnimationAmount: Double = 1
        static let circleAnimationDecrease: Double = 0.6
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForEach(ColorScheme.allCases, id: \.self) {
            
            LiveView(viewModel: LiveViewModel.mockLiveSoonHours)
                .preferredColorScheme($0)
                .previewDisplayName("Soon hours \($0)")
            
            LiveView(viewModel: LiveViewModel.mockLiveSoon)
                .preferredColorScheme($0)
                .previewDisplayName("Soon \($0)")
            
            LiveView(viewModel: LiveViewModel.mockLiveAboutToStart)
                .preferredColorScheme($0)
                .previewDisplayName("About to start \($0)")
            
            LiveView(viewModel: LiveViewModel.mockLive)
                .preferredColorScheme($0)
                .previewDisplayName("Live \($0)")
        }
    }
}
