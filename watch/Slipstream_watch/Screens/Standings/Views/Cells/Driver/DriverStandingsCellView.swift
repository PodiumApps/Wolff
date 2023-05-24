import SwiftUI

struct DriverStandingsCellView<ViewModel: DriverStandingsCellViewModelRepresentable>: View {

    @State private var showDriverDetails: Bool = false

    private let viewModel: ViewModel
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
                    showDriverDetails.toggle()
                }) {
                    Image(systemName: "ellipsis.circle.fill")
                        .padding(5)
                }
            }

            HStack {
                HStack(alignment: .bottom, spacing: 2) {
                    Text(viewModel.points.description)
                        .font(.Caption.semibold)
                    Text(Localization.SeasonDriverStandings.points)
                        .font(.Caption.regular)
                }

                Spacer()

                HStack(alignment: .bottom, spacing: 2) {
                    Text(Localization.SeasonDriverStandings.carNo)
                        .font(.Caption.regular)
                    Text(viewModel.carNumber.description)
                        .font(.Caption.semibold)
                        .italic()
                }
            }
        }
        .padding(.vertical, Constants.Card.padding)
        .listRowBackground(
            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                .fill(constructorStyler.constructor.color.opacity(Constants.Card.backgroundOpacity))
        )
        .sheet(isPresented: $showDriverDetails) {
            EmptyView()
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
