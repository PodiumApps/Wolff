import SwiftUI

struct ConstructorStandingsDetailsView<ViewModel: ConstructorStandingsDetailsViewModelRepresentable>: View {

    @ObservedObject var viewModel: ViewModel

    private let constructorStyler: ConstructorStylerRepresentable

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: viewModel.constructorID)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .error(let error):
                Text(error)
            case .loading:
                ProgressView()
            case .results(let infoComponents, let constructorName):
                VStack(alignment: .leading) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(constructorName)
                                .font(.Body.semibold)
                            ForEach(0 ..< infoComponents.count, id: \.self) { index in
                                VStack(alignment: .leading) {
                                    Divider()
                                    Text(infoComponents[index].key.uppercased())
                                        .font(.Body.regular)
                                        .foregroundColor(constructorStyler.constructor.color)
                                    Text(infoComponents[index].value)
                                        .font(.Body.medium)
                                }
                            }
                        }
                        .padding(.horizontal, .Spacing.default)
                    }
                }
            }
        }
        .onAppear {
            viewModel.action.send(.loadConstructorDetails)
        }
    }
}
