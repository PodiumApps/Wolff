import SwiftUI

@main
struct SlipstreamWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(viewModel: AppViewModel.make())
        }
    }
}
