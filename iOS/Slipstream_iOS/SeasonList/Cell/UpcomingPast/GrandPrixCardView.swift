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
                VStack(alignment: .leading, spacing: 12) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.title)
                            .font(.system(size: 15, weight: .bold))
                        HStack {
                            
                            Text(viewModel.subtitle)
                                .font(.system(size: 15, weight: .semibold))
                            
                            Text(Localization.GrandPrixCard.Top.round(viewModel.round))
                                .font(.system(size: 13))
                        }
                    }
                    
                    HStack {
                        Text(viewModel.grandPrixDate)
                            .font(.system(size: 14, weight: .semibold))
                        
                        if let label = viewModel.nextSession {
                            Text("in " + label)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                }
                .padding()
                .frame(width: 240, height: Constants.Card.height, alignment: .leading)
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
        .frame(width: 240, height: Constants.Card.height)
    }
}

fileprivate enum Constants {
    
    enum Card {
        
        static let height: CGFloat = 95
        static let cornerRadius: CGFloat = 8
        static let contentPadding: CGFloat = 12
        static let horizontalShadow: CGFloat = 3
        static let verticalShadow: CGFloat = 3
        static let verticalSpacing: CGFloat = 7
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
