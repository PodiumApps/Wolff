import SwiftUI

struct NewsCellView<ViewModel: NewsCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack {
            Text(viewModel.news.title)
                .font(.Caption.medium)
        }
    }
}
