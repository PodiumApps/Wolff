import SwiftUI

struct DriverDetailsTextView: View {
    
    private let titleRegular: String
    private let titleBold: String
    private let detailsText: String
    private let color: Color
    
    init(titleRegular: String, titleBold: String, detailsText: String, color: Color) {
        
        self.titleRegular = titleRegular
        self.titleBold = titleBold
        self.detailsText = detailsText
        self.color = color
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: Constants.Spacing.horizontalStacks) {
            HStack(alignment: .bottom, spacing: Constants.Spacing.horizontalStacks) {
                Text(titleRegular)
                    .fontWeight(.regular)
                Text(titleBold)
                    .foregroundColor(color)
                    .font(.driverPositionFont)
                    .fontWeight(.semibold)
            }
            Text(detailsText)
                .fontWeight(.thin)
        }
    }
}

fileprivate enum Constants {
    
    enum Spacing {
        
        static let horizontalStacks: CGFloat = 4
    }
}

struct DriverDetailsTextView_Previews: PreviewProvider {
    static var previews: some View {
        DriverDetailsTextView(titleRegular: "MARC", titleBold: "Verstappen", detailsText: "Red bull", color: .green)
    }
}
