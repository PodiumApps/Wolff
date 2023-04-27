import SwiftUI

struct TrackInfoView<ViewModel: TrackInfoViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .leading) {
            ScrollView {
                ForEach(0 ..< viewModel.infoComponents.count, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Divider()
                        Text(viewModel.infoComponents[index].key.uppercased())
                            .font(.Body.regular)
                            .foregroundColor(.accentColor)
                        Text(viewModel.infoComponents[index].value)
                            .font(.Body.medium)
                    }
                    .padding(.horizontal, Constants.Padding.horizontal)
                }
            }
        }
        .navigationTitle(Localization.TrackInfo.screenTitle)
    }
}

fileprivate enum Constants {

    enum Padding {

        static let horizontal: CGFloat = 5
    }
}
