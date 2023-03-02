import SwiftUI

struct SessionDriverRowView<ViewModel: SessionDriverRowViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel
    
    var action: ()->Void

    init(viewModel: ViewModel,  action: @escaping(() -> Void)) {
        
        self.viewModel = viewModel
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(alignment: .center, spacing: 0) {
                Text("\(viewModel.position)")
                    .padding(.vertical, Constants.Label.verticalPadding)
                    .foregroundColor(viewModel.isSelected ? .white : .primary)
                    .frame(width: 45)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.Row.cornerRadius)
                            .fill(
                                self.viewModel.isSelected
                                ? Color.SessionDriverRow.positionBackground
                                : .clear
                            )
                    )
                
                VStack {
                    HStack {
                        createLabel(for: viewModel.driverTicker.uppercased())
                        createLabel(for: viewModel.timeGap ?? "", with: .red)
                        createLabel(for: "\(viewModel.tyrePitCount)")
                        createLabel(for: viewModel.currentTyre.name, with: viewModel.currentTyre.color)
                    }
                }
                .padding(.vertical, Constants.Label.verticalPadding)
                .padding(.trailing, Constants.Label.trailingPadding)
                .frame(minWidth: Constants.Label.minWidth, maxWidth: Constants.Label.maxWidth)
            }
        }
        .buttonStyle(ButtonRowStyle(isSelected: viewModel.isSelected))
    }

    private func createLabel(for info: String, with color: Color = .primary) -> some View {
        
        Text(info)
            .minimumScaleFactor(0.9)
            .frame(
                minWidth: Constants.Label.minWidth,
                maxWidth: Constants.Label.maxWidth,
                minHeight: 0,
                maxHeight: 20
            )
            .truncationMode(.tail)
            .foregroundColor(color)
            .font(.body)
            .fontWeight(viewModel.isSelected ? .heavy : .light)
    }
}

private struct ButtonRowStyle: ButtonStyle {
    
    private let isSelected: Bool
    
    init(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
      configuration.label
        .background(
            configuration.isPressed
            ? Color.SessionDriverRow.rowBackground.opacity(0.25)
            : isSelected ? Color.SessionDriverRow.rowBackground : Color(UIColor.systemBackground)
        )
        .cornerRadius(Constants.Row.cornerRadius)
    }

  }

fileprivate enum Constants {

    enum Row {

        static let cornerRadius: CGFloat = 10
    }

    enum Label {

        static let minWidth: CGFloat = 0
        static let maxWidth: CGFloat = .infinity

        static let verticalPadding: CGFloat = 5
        static let horizontalPadding: CGFloat = 10
        static let trailingPadding: CGFloat = 10
    }
}

struct SessionDriverRowView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDriverRowView(
            viewModel: SessionDriverRowViewModel(
                position: 2,
                driverTicker: "HAM",
                timeGap: "+2.344",
                tyrePitCount: 3,
                currentTyre: .medium
            )
        ) {
            
        }
    }
}
