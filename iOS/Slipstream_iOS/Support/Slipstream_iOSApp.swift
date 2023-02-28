import SwiftUI

@main
struct Slipstream_iOSApp: App {
    
    init() {
        
        print(Date().tokenString)
    }
    
    var body: some Scene {
        WindowGroup {
            SessionStandingsListView(
                viewModel: SessionStandingsListViewModel(
                    standings: [
                        SessionDriverRowViewModel(
                            position: "30",
                            driverTicker: "HAM",
                            timeGap: "-",
                            tyrePitCount: "1",
                            currentTyre: .intermediate
                        ),
                        SessionDriverRowViewModel(
                            position: "2",
                            driverTicker: "VER",
                            timeGap: "+2.344",
                            tyrePitCount: "3",
                            currentTyre: .wet
                        ),
                        SessionDriverRowViewModel(
                            position: "3",
                            driverTicker: "RUS",
                            timeGap: "+3.531",
                            tyrePitCount: "2",
                            currentTyre: .soft
                        ),
                        SessionDriverRowViewModel(
                            position: "4",
                            driverTicker: "LEC",
                            timeGap: "+3.562",
                            tyrePitCount: "3",
                            currentTyre: .medium
                        ),
                        SessionDriverRowViewModel(
                            position: "5",
                            driverTicker: "SAI",
                            timeGap: "+4.143",
                            tyrePitCount: "4",
                            currentTyre: .hard
                        )
                    ]
                )
            )
        }
    }
}
