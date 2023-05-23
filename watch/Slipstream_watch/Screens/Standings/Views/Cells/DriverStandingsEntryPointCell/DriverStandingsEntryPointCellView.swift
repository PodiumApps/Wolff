import SwiftUI

struct DriverStandingsEntryPointCellView<ViewModel: DriverStandingsEntryPointCellViewModelRepresentable>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Picker("Selection", selection: $viewModel.selection) {
                ForEach(DriverStandingsEntryPointCellViewModel.Selection.allCases) { selection in
                    Text(selection.rawValue.capitalized)
                }
            }

            switch viewModel.selection {
            case .drivers: EmptyView()
            case .constructors: EmptyView()
            }
        }
        .pickerStyle(.navigationLink)

//        Button(action: {
//            viewModel.tapCell()
//        }) {
//            VStack(alignment: .leading, spacing: 5) {
//                Text("Drivers")
//                    .font(.Body.bold)
//                createPodiumList(podium: viewModel.podium)
//            }
//        }
//        .listRowBackground(
//            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
//                .fill(Color.Event.watchCompletedOrUpcomingEvent)
//        )
    }

//    private func createPodiumList(podium: [String]) -> some View {
//
//        HStack(alignment: .bottom, spacing: .Spacing.default2) {
//            ForEach(0 ..< podium.count, id: \.self) { index in
//                HStack(alignment: .bottom, spacing: .Spacing.default) {
//                    HStack(spacing: .zero) {
//                        Text(Localization.Podium.ordinalComponent(index + 1))
//                            .opacity(Constants.Podium.OrdinalComponent.opacity)
//                    }
//                    .font(.Caption.medium)
//                    .lineLimit(Constants.Podium.DriverTicker.lineLimit)
//
//                    Text(podium[index])
//                        .font(.Caption.semibold)
//                        .lineLimit(Constants.Podium.DriverTicker.lineLimit)
//                }
//            }
//        }
//    }
}

fileprivate enum Constants {

    enum Card {

        static let cornerRadius: CGFloat = 17
    }

    enum Podium {

        enum OrdinalComponent {

            static let opacity: CGFloat = 0.70
        }

        enum DriverTicker {

            static let lineLimit: Int = 1
        }
    }
}
