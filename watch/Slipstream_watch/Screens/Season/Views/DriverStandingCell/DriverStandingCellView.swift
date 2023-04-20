import SwiftUI

struct DriverStandingCellView<ViewModel: DriverStandingCellViewModel>: View {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("\(String(viewModel.position)).")
                            Text(viewModel.firstName)

                            Spacer()

                        }
                        .font(.Caption.semibold)

                        VStack(alignment: .leading, spacing: 3) {
                            Text(viewModel.lastName)
                                .font(.Body.semibold)
                            Text(viewModel.team.fullName)
                                .font(.Caption.semibold)
                                .foregroundColor(Color.Constructor.redBull)
                        }
                    }

                    Text("Car \(viewModel.carNumber)")
                        .font(.Caption2.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.Constructor.redBull)
                        .clipShape(Capsule())
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("Time / Gap")
                            .font(.Caption.semibold)
                        Text(viewModel.time ?? "Leader")
                            .font(.Caption.regular)
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("Tyre")
                            .font(.Caption.semibold)
                        Text("Medium")
                            .font(.Caption.semibold)
                            .foregroundColor(Color.Tyre.medium)
                    }
                }
            }

            Spacer()
        }
        .padding(15)
        .background(Color.Constructor.redBull.opacity(0.35))
        .cornerRadius(20)
    }

//    private func getBackgroundColor(for constructor: Constructor) {
//
//        switch constructor.id {
//        case
//        }
//    }
}

struct DriverStandingCellView_Previews: PreviewProvider {
    static var previews: some View {
        DriverStandingCellView(viewModel: DriverStandingCellViewModel(firstName: "Max", lastName: "Verstappen", team: .mockRedBull, position: 1, time: "+1.539", carNumber: 1, tyre: .medium))
    }
}
