import SwiftUI

@main
struct Slipstream_iOSApp: App {
    
    init() {   
        print(Date().tokenString)
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(viewModel: AppViewModel.make())
        }
    }
}
