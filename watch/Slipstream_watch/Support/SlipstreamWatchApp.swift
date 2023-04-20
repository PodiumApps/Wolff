import SwiftUI

@main
struct SlipstreamWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            //AppView(viewModel: AppViewModel.make())
            DriverStandingCellView(viewModel: DriverStandingCellViewModel(firstName: "Max", lastName: "Verstappen", team: .mockRedBull, position: 1, time: "+1.539", carNumber: 1, tyre: .medium))
        }
    }
}
