import SwiftUI

struct DriverStandingCellView<ViewModel: DriverStandingCellViewModel>: View {

    @ObservedObject private var viewModel: ViewModel
    private var constructorStyler: ConstructorStylerRepresentable

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: viewModel.constructor.id)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Constants.Card.verticalSpacing) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text(Localization.Podium.ordinalComponent(viewModel.position))
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
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text(Localization.DriverStandingsCell.timeGap)
                            .font(.Caption.semibold)
                        Text(viewModel.time.last ?? Localization.DriverStandingsCell.leader)
                            .font(.Caption.regular)
                    }

                    Spacer()

                    if let tyre = viewModel.tyre {
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

            Spacer()
        }
        .padding(Constants.Card.padding)
        .background(constructorStyler.constructor.color.opacity(Constants.Card.backgroundOpacity))
        .cornerRadius(Constants.Card.cornerRadius)
    }
}

fileprivate enum Constants {

    enum Card {

        static let verticalSpacing: CGFloat = 10
        static let padding: CGFloat = 10
        static let backgroundOpacity: CGFloat = 0.20
        static let cornerRadius: CGFloat = 20
    }

    enum LastNameTeamNameSection {

        static let verticalSpacing: CGFloat = 3
        static let teamLineLimit: Int = 2
    }
}
