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
        
        VStack(alignment: .leading, spacing: .Spacing.default) {
            HStack(alignment: .bottom, spacing: .Spacing.default) {
                Text(titleRegular)
                    .font(.Body.regular)
                Text(titleBold)
                    .foregroundColor(color)
                    .font(.Body.bold)
            }
            Text(detailsText)
                .font(.Caption.regular)
        }
    }
}

struct DriverDetailsTextView_Previews: PreviewProvider {
    static var previews: some View {
        DriverDetailsTextView(titleRegular: "MARC", titleBold: "Verstappen", detailsText: "Red bull", color: .green)
    }
}
