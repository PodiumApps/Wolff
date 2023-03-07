import SwiftUI

struct SessionDriverRowView<ViewModel: SessionDriverRowViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel
    private let sessionDriverStyler: SessionDriverStylerRepresentable
    
    var action: ()->Void

    init(viewModel: ViewModel,  action: @escaping(() -> Void)) {
        
        self.viewModel = viewModel
        self.action = action
        self.sessionDriverStyler = SessionDriverStyler(
            tyre: viewModel.currentTyre,
            constructorId: viewModel.constructorId
        )
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(alignment: .center, spacing: 0) {
                Text("\(viewModel.position)")
                    .padding(.vertical, Constants.Label.verticalPadding)
                    .foregroundColor(viewModel.isSelected ? .white : .primary)
                    .frame(width: Constants.Position.width, height: Constants.Position.height)
                    .background(
                        
                        RoundedRectangle(cornerRadius: Constants.Row.cornerRadius)
                            .fill(sessionDriverStyler.constructorStyler.constructor.color.gradient)
                            .opacity(viewModel.isSelected ? 1 : 0)
                    )
                
                VStack {
                    HStack {
                        HStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: Constants.Row.constructorRectangleRadius)
                                .fill(sessionDriverStyler.constructorStyler.constructor.color.gradient)
                                .frame(width: Constants.Row.constructorRectangleWidth)
                                .opacity(viewModel.isSelected ? 0 : 1)
                            
                            createLabel(for: viewModel.driverTicker.uppercased())
                            Spacer()
                        }
                        createLabel(
                            for: viewModel.timeGap ?? "",
                            with: viewModel.position == 1
                                ? .SessionDriverRow.firstPlaceTime
                                : .SessionDriverRow.secondPlaceTime
                        )
                        createLabel(for: "\(viewModel.tyrePitCount)")
                        
                        createLabel(for: sessionDriverStyler.tyre.ticker, with: .white, font: .caption)
                            .padding(Constants.Row.tyrePadding)
                            .background(
                                Circle()
                                    .fill(sessionDriverStyler.tyre.color.gradient)
                                    .shadow(radius: 1)
                            )
                    }
                }
                .padding(.vertical, Constants.Label.verticalPadding)
                .padding(.trailing, Constants.Label.trailingPadding)
                .frame(minWidth: Constants.Label.minWidth, maxWidth: Constants.Label.maxWidth)
            }
        }
        .buttonStyle(
            ButtonRowStyle(
                isSelected: viewModel.isSelected,
                cornerRadius: Constants.Row.cornerRadius,
                selectedColor: sessionDriverStyler.constructorStyler.constructor.color
            )
        )
    }

    private func createLabel(for info: String, with color: Color = .primary, font: Font = .body) -> some View {
        
        Text(info)
            .minimumScaleFactor(Constants.Label.minimumScaleFactor)
            .frame(
                minWidth: Constants.Label.minWidth,
                maxWidth: Constants.Label.maxWidth,
                minHeight: 0,
                maxHeight: Constants.Label.maxHeight
            )
            .truncationMode(.tail)
            .foregroundColor(color)
            .font(font)
            .fontWeight(viewModel.isSelected ? .bold : .regular)
    }
}

fileprivate enum Constants {
    
    enum Position {
        
        static let width: CGFloat = 45
        static let height: CGFloat = 35
    }

    enum Row {

        static let cornerRadius: CGFloat = 10
        static let constructorRectangleRadius: CGFloat = 5
        static let constructorRectangleWidth: CGFloat = 5
        static let tyrePadding: CGFloat = 4
    }

    enum Label {

        static let minWidth: CGFloat = 0
        static let maxWidth: CGFloat = .infinity
        static let maxHeight: CGFloat = 20
        static let minimumScaleFactor: CGFloat = 0.9

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
                currentTyre: .medium,
                constructorId: "mercedes"
            )
        ) {
            
        }
    }
}
