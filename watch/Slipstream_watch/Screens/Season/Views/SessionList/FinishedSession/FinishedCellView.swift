import SwiftUI

struct FinishedCellView<ViewModel: FinishedSessionCellViewModelRepresentable>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct FinishedCellView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedCellView(
            viewModel: FinishedSessionCellViewModel(
                session: "Race",
                winners: ["VER", "ALO", "LEC"]
            )
        )
    }
}
