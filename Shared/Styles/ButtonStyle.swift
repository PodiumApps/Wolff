import SwiftUI

struct ButtonRowStyle: ButtonStyle {
    
    private let isSelected: Bool
    private let selectedColor: Color
    private let cornerRadius: CGFloat
    
    init(isSelected: Bool, cornerRadius: CGFloat = 8, selectedColor: Color) {
        
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
        self.selectedColor = selectedColor
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
      configuration.label
        .background(
            configuration.isPressed
                ? Color.SessionDriverRow.rowBackground.opacity(0.25)
                : isSelected ? selectedColor.opacity(0.2) : Color(UIColor.systemBackground)
        )
        .cornerRadius(cornerRadius)
    }
  }
