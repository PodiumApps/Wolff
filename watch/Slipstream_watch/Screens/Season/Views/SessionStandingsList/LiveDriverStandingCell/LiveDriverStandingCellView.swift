import SwiftUI

struct LiveDriverStandingCellView<ViewModel: LiveDriverStandingCellViewModel>: View {

    @State private var showDriverSessionDetails: Bool = false

    @ObservedObject private var viewModel: ViewModel
    private var constructorStyler: ConstructorStylerRepresentable
    private let position: Int

    init(viewModel: ViewModel, position: Int) {
        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: viewModel.constructor.id)
        self.position = position
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Card.verticalSpacing) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text(Localization.Podium.ordinalComponent(position))
                        Text(viewModel.firstName)

                        Spacer()

                    }
                    .font(.Body.regular)

                    VStack(alignment: .leading, spacing: Constants.LastNameTeamNameSection.verticalSpacing) {
                        Text(viewModel.lastName)
                            .font(.Body.semibold)
                        Text(viewModel.constructor.fullName)
                            .lineLimit(Constants.LastNameTeamNameSection.teamLineLimit)
                            .font(.Caption.semibold)
                            .foregroundColor(constructorStyler.constructor.color)
                    }
                }

                Button(action: {
                    showDriverSessionDetails.toggle()
                }) {
                    Image(systemName: "ellipsis.circle.fill")
                        .padding(5)
                }
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(Localization.DriverStandingsCell.timeGap)
                        .font(.Caption.semibold)
                    Text(viewModel.time.last ?? Localization.DriverStandingsCell.leader)
                        .font(.Caption.regular)
                }

                Spacer()

                if let _ = viewModel.tyre {
                    VStack(alignment: .leading) {
                        Text(Localization.DriverStandingsCell.tyre)
                            .font(.Caption.semibold)
                        Text("Medium")
                            .font(.Caption.semibold)
                            .foregroundColor(Color.Tyre.medium)
                    }
                }
            }
        }
        .padding(.vertical, Constants.Card.padding)
        .listRowBackground(
            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                .fill(constructorStyler.constructor.color.opacity(Constants.Card.backgroundOpacity))
        )
        .sheet(isPresented: $showDriverSessionDetails) {
            Text("Driver details for session")
        }
    }
}

fileprivate enum Constants {

    enum Card {

        static let verticalSpacing: CGFloat = 10
        static let padding: CGFloat = 10
        static let backgroundOpacity: CGFloat = 0.40
        static let cornerRadius: CGFloat = 20
    }

    enum LastNameTeamNameSection {

        static let verticalSpacing: CGFloat = 3
        static let teamLineLimit: Int = 2
    }
}
