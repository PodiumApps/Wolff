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
                    .frame(width: 45, height: 35)
                    .background(
                        
                        RoundedRectangle(cornerRadius: Constants.Row.cornerRadius)
                            .fill(sessionDriverStyler.constructorStyler.constructor.color.gradient)
                            .opacity(viewModel.isSelected ? 1 : 0)
                    )
                
                VStack {
                    HStack {
                        HStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(sessionDriverStyler.constructorStyler.constructor.color.gradient)
                                .frame(width: 5)
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
                        
                        createLabel(for: sessionDriverStyler.tyre.thicker, with: .white, font: .caption)
                            .padding(4)
                            .background(
                                Circle()
                                    .fill(sessionDriverStyler.tyre.color.gradient)
//                                    .strokeBorder(.black, lineWidth: 1)
//                                    .background(Circle().fill(sessionDriverStyler.tyre.color.gradient))
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
            .minimumScaleFactor(0.9)
            .frame(
                minWidth: Constants.Label.minWidth,
                maxWidth: Constants.Label.maxWidth,
                minHeight: 0,
                maxHeight: 20
            )
            .truncationMode(.tail)
            .foregroundColor(color)
            .font(font)
            .fontWeight(viewModel.isSelected ? .bold : .regular)
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
                currentTyre: .medium,
                constructorId: "mercedes"
            )
        ) {
            
        }
    }
}
