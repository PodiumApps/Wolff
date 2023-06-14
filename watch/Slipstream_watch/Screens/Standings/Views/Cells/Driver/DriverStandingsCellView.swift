import SwiftUI

struct DriverStandingsCellView<ViewModel: DriverStandingsCellViewModelRepresentable>: View {

    @ObservedObject var viewModel: ViewModel
    private let constructorStyler: ConstructorStylerRepresentable

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: viewModel.constructor.id)
    }
    
    var body: some View {
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

                Button(action: {
                    viewModel.action.send(.openDetailsView)
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .padding(5)
                }
            }

            HStack {

                HStack(alignment: .bottom, spacing: 2) {
                    Text(Localization.SeasonDriverStandings.carNo)
                        .font(.Caption.regular)
                    Text(viewModel.carNumber.description)
                        .font(.Caption.semibold)
                }

                Spacer()

                HStack(alignment: .bottom, spacing: 2) {
                    Text(viewModel.points.description)
                        .font(.Caption.semibold)
                    Text(Localization.SeasonDriverStandings.points)
                        .font(.Caption.regular)
                }
            }
        }
        .padding(.vertical, Constants.Card.padding)
        .listRowBackground(
            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                .fill(constructorStyler.constructor.color.opacity(Constants.Card.backgroundOpacity))
        )
//        .fullScreenCover(isPresented: $viewModel.showDriverDetailsSheet) {
//            DriverStandingsDetailsView(viewModel: DriverStandingsDetailsViewModel.make(
//                driverName: "\(viewModel.firstName) \(viewModel.lastName)",
//                driverID: viewModel.driverID,
//                constructorID: viewModel.constructor.id
//            ))
//        }
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
