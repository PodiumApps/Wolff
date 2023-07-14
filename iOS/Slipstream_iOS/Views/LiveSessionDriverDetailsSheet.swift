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
                    DriverDetailsTextView(
                        titleRegular: viewModel.titleRegular,
                        titleBold: viewModel.titleBold,
                        detailsText: viewModel.detailsText,
                        color: constructorStyler.constructor.color
                    )
                    Spacer()
                    CarWithNumberView(color: constructorStyler.constructor.color, circleText: viewModel.circleText)
                    
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
                }
                
                
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
    }
    
    enum Background {
        
        static let cornerRadius: CGFloat = 16
        static let opacity: CGFloat = 0.05
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
