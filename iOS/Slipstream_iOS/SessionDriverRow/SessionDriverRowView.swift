import SwiftUI

struct SessionDriverRowView<ViewModel: SessionDriverRowViewModelRepresentable>: View {

    @ObservedObject var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(viewModel.position)
                .padding(.vertical, Constants.Label.verticalPadding)
                .foregroundColor(viewModel.isSelected ? .white : .primary)
                .frame(width: 45)
                .background(
                    RoundedRectangle(cornerRadius: Constants.Row.cornerRadius)
                        .fill(
                            self.viewModel.isSelected ? Color.SessionDriverRow.positionBackground : Color(UIColor.systemBackground))
                        )

            VStack {
                HStack {
//                    Spacer()
                    createLabel(for: viewModel.driverTicker.uppercased())
//                    Spacer()
                    createLabel(for: viewModel.timeGap, with: .red)
//                    Spacer()
                    createLabel(for: viewModel.tyrePitCount)
//                    Spacer()
                    createLabel(for: viewModel.currentTyre.name, with: viewModel.currentTyre.color)
//                    Spacer()
                }
            }
            .padding(.vertical, Constants.Label.verticalPadding)
            .padding(.trailing, Constants.Label.trailingPadding)
            .frame(minWidth: Constants.Label.minWidth, maxWidth: Constants.Label.maxWidth)
        }
        .font(.body).bold()
        .background(viewModel.isSelected ? Color.SessionDriverRow.rowBackground : Color(UIColor.systemBackground))
        .clipShape(
            RoundedRectangle(cornerRadius: Constants.Row.cornerRadius)
        )
    }

    func createLabel(for info: String, with color: Color = .primary) -> some View {
        
        Text(info)
            .foregroundColor(color)
            .minimumScaleFactor(0.9)
            .frame(
                minWidth: Constants.Label.minWidth,
                maxWidth: Constants.Label.maxWidth,
                minHeight: 0,
                maxHeight: 20
            )
            .truncationMode(.tail)
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
                position: "2",
                driverTicker: "HAM",
                timeGap: "+2.344",
                tyrePitCount: "3",
                currentTyre: .medium
            )
        )
    }
}
