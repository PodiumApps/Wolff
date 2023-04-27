import Foundation

protocol TrackInfoViewModelRepresentable {

    var infoComponents: [(key: String, value: String)] { get }
}

final class TrackInfoViewModel: TrackInfoViewModelRepresentable {

    var infoComponents: [(key: String, value: String)]

    init(raceDistance: Double, trackLength: Double, firstGrandPrix: Int, lapRecord: String) {

        self.infoComponents = [
            (key: Localization.TrackInfo.lapRecord, value: lapRecord),
            (key: Localization.TrackInfo.firstGrandPrix, value: String(firstGrandPrix)),
            (key: Localization.TrackInfo.trackLength, value: Localization.TrackInfo.trackLengthValue(trackLength)),
            (key: Localization.TrackInfo.raceDistance, value: Localization.TrackInfo.raceDistanceValue(raceDistance))
        ]
    }
}
