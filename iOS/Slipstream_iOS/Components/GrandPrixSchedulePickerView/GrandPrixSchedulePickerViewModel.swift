import Foundation

protocol GrandPrixSchedulePickerViewModelRepresentable {

    var scheduleCarouselComponents: [ScheduleCarouselViewModel] { get }
}

final class GrandPrixSchedulePickerViewModel: GrandPrixSchedulePickerViewModelRepresentable {

    var scheduleCarouselComponents: [ScheduleCarouselViewModel]

    init(scheduleCarouselComponents: [ScheduleCarouselViewModel]) {
        self.scheduleCarouselComponents = scheduleCarouselComponents
    }
}
