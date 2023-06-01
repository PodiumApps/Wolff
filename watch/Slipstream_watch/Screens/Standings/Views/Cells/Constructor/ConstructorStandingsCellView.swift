import SwiftUI

struct ConstructorStandingsCellView<ViewModel: ConstructorStandingsCellViewModelRepresentable>: View {

    @State private var showConstructorDetails: Bool = false

    @ObservedObject var viewModel: ViewModel
    private let constructorStyler: ConstructorStylerRepresentable

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: viewModel.constructorID)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Card.verticalSpacing) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text(Localization.Podium.ordinalComponent(viewModel.position))
                        Text(viewModel.name)
                            .font(.Body.semibold)
                            .foregroundColor(constructorStyler.constructor.color)

                        Spacer()

                    }
                    .font(.Body.regular)
                }

                Button(action: {
                    showConstructorDetails.toggle()
                }) {
                    Image(systemName: "ellipsis.circle.fill")
                }
            }

            HStack(alignment: .bottom) {

                VStack(alignment: .leading) {
                    Text(Localization.SeasonConstructorStandings.teamPrinciple)
                        .font(.Caption.regular)
                    Text(viewModel.teamPrinciple)
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
        .fullScreenCover(isPresented: $showConstructorDetails) {
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
