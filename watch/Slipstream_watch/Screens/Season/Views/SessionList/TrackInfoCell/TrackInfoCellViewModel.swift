import Foundation

protocol TrackInfoCellViewModelRepresentable {

    var trackName: String { get }
}

final class TrackInfoCellViewModel: TrackInfoCellViewModelRepresentable {

    var trackName: String

    init(trackName: String) {
        self.trackName = trackName
    }
}
