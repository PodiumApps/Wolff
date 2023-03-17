import SwiftUI

struct GrandPrixCardView<ViewModel: GrandPrixCardViewModelRepresentable>: View {
    
    private let viewModel: ViewModel
    private let action: ()->Void
    
    init(viewModel: ViewModel, action: @escaping(() -> Void)) {
        
        self.viewModel = viewModel
        self.action = action
    }
    
    var body: some View {
        
        
        Button(action: {
            action()
        }) {
            ZStack {
                VStack(alignment: .leading, spacing: .Spacing.default3) {
                    
                    VStack(alignment: .leading, spacing: .Spacing.default) {
                        Text(viewModel.title)
                            .font(.Title4.bold)
                        HStack {
                            
                            Text(viewModel.subtitle)
                                .font(.Body.semibold)
                            
                            Text(Localization.GrandPrixCard.Top.round(viewModel.round))
                                .font(.Caption.regular)
                        }
                    }
                    
                    HStack {
                        if !viewModel.winners.isEmpty {
                            HStack(spacing: .Spacing.default2) {
                                ForEach(0 ..< viewModel.winners.count, id: \.self) { index in
                                    HStack(spacing: .Spacing.default) {
                                        Text("\(index + 1)")
                                            .font(.Caption.semibold)
                                        + Text((index + 1).getPositionString)
                                            .font(.Superscript.semibold)
                                            .baselineOffset(Constants.Card.baselineOffset)
                                        
                                        Text(viewModel.winners[index])
                                            .font(.Body.bold)
                                    }
                                }
                            }
                        } else {
                            Text(viewModel.grandPrixDate)
                                .font(.Body.regular)
                        }
                        
                        if let label = viewModel.nextSession {
                            Text(Localization.GrandPrixCard.Label.time(label))
                                .font(.Body.bold)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                }
                .padding()
                .frame(width: Constants.Card.width, height: Constants.Card.height, alignment: .leading)
            }
        }
        .foregroundColor(.primary)
        .background(
            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                .fill(Color(UIColor.systemGray6))
                .shadow(
                    radius: Constants.Card.shadowRadius,
                    x: Constants.Card.horizontalShadow,
                    y: Constants.Card.verticalShadow
                )
        )
        .frame(width: Constants.Card.width, height: Constants.Card.height)
    }
}

fileprivate enum Constants {
    
    enum Card {
        
        static let height: CGFloat = 95
        static let width: CGFloat = 240
        static let cornerRadius: CGFloat = 8
        static let contentPadding: CGFloat = 12
        static let horizontalShadow: CGFloat = 3
        static let verticalShadow: CGFloat = 3
        static let verticalSpacing: CGFloat = 7
        static let shadowRadius: CGFloat = 3
        static let baselineOffset: CGFloat = 4.0
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
        
        ForEach(ColorScheme.allCases, id: \.self) {
            
            GrandPrixCardView(viewModel: GrandPrixCardViewModel.mockShortDate){}
                .preferredColorScheme($0)
                .previewDisplayName("Short Date \($0)")
            
            GrandPrixCardView(viewModel: GrandPrixCardViewModel.mockFullDate){}
                .preferredColorScheme($0)
                .previewDisplayName("Full Date \($0)")
            
            GrandPrixCardView(viewModel: GrandPrixCardViewModel.mockNextFullDate) {}
                .preferredColorScheme($0)
                .previewDisplayName("Next Full Date \($0)")
        }
    }
}
