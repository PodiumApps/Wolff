import SwiftUI

struct LiveEventCardView<ViewModel: LiveEventCardViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        Button(action: {

        }) {
            HStack {
                VStack(alignment: .leading, spacing: .Spacing.default2) {
                    VStack(alignment: .leading) {
                        Text(viewModel.title)
                            .font(.Body.semibold)
                        HStack(spacing: .Spacing.default3) {
                            HStack(spacing: .Spacing.default) {
                                Text("🇧🇪")
                                Text(viewModel.country)
                                    .font(.system(size: 12, weight: .medium))
                            }
                            Text("Round \(viewModel.round.description)")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color.red)
                        }
                    }

                    VStack(alignment: .leading, spacing: 1) {
                        Text(viewModel.sessionName)
                            .font(.system(size: 12, weight: .bold))
                        Text("Happening Now".uppercased())
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.red)
                    }
                }

                Spacer()
            }
        }
        .background(Color.red.opacity(0.27))
        .buttonBorderShape(
            .roundedRectangle(radius: 10)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
    }
}

struct LiveEventCardView_Previews: PreviewProvider {
    static var previews: some View {
        LiveEventCardView(
            viewModel: LiveEventCardViewModel(
                id: .init("event"),
                title: "Spa-Francorchamps",
                country: "Belgium",
                round: 18,
                timeInterval: .init(100),
                sessionName: "Qualifying"
            )
        )
    }
}
