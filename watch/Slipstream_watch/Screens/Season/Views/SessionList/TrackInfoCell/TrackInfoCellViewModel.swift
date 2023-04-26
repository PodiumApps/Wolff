import Foundation

protocol TrackInfoCellViewModelRepresentable {

    var event: Event { get }
}

final class TrackInfoCellViewModel: TrackInfoCellViewModelRepresentable {

    var event: Event

    init(event: Event) {
        self.event = event
    }
}
