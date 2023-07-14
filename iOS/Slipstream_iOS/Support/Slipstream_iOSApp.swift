import SwiftUI

@main
struct Slipstream_iOSApp: App {
    
    var body: some Scene {
        WindowGroup {
            AppView(viewModel: AppViewModel.make())
        }
    }
}
