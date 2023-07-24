import Foundation

protocol TrackInfoCellViewModelRepresentable {

    var event: Event { get }
}

final class TrackInfoCellViewModel: TrackInfoCellViewModelRepresentable {

    let event: Event

    init(event: Event) {
        self.event = event
    }
}
