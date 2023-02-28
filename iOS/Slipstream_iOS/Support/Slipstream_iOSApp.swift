import SwiftUI

@main
struct Slipstream_iOSApp: App {
    
    init() {
        
        print(Date().tokenString)
    }
    
    var body: some Scene {
        WindowGroup {
            GrandPrixSchedulePickerView(
                viewModel: GrandPrixSchedulePickerViewModel(
                    scheduleCarouselComponents: [
                        ScheduleCarouselViewModel(
                            round: 13,
                            title: "Spa-Francorchamps",
                            grandPrixDate: "24-27 Set",
                            eventStatus: .upcoming(details: "05-07 MAY")
                        ),
                        ScheduleCarouselViewModel(
                            round: 13,
                            title: "Spa-Francorchamps",
                            grandPrixDate: "24-27 Set",
                            eventStatus: .current(
                                title: "FP1",
                                details: "10:30h until start"
                            )
                        ),
                        ScheduleCarouselViewModel(
                            round: 13,
                            title: "Spa-Francorchamps",
                            grandPrixDate: "24-27 Set",
                            eventStatus: .current(
                                title: "FP1",
                                details: "10:30h until start"
                            )
                        ),
                        ScheduleCarouselViewModel(
                            round: 13,
                            title: "Spa-Francorchamps",
                            grandPrixDate: "24-27 Set",
                            eventStatus: .finished(
                                drivers: [
                                    .init(driverTicker: "HAM", value: .first),
                                    .init(driverTicker: "LEC", value: .second),
                                    .init(driverTicker: "VER", value: .third)
                                ]
                            )
                        )
                    ]
                )
            )
        }
    }
}
