import SwiftUI

extension Font {

    static let subheadlineFont: Self = .subheadline
    static let titleFontBold: Self = .system(.title2, weight: .bold)
    static let driverPositionFont: Self = .system(.title3, weight: .bold)
    static let driverTickerFont: Self = .system(.headline, weight: .bold)

    static let newsCarouselPositionFont: Self = .system(size: 45, weight: .bold)
    static let newsCarouselDriverNameFont: Self = .headline
    static let newsCarouselConstrutorNameFont: Self = .subheadline.italic()

    static let eventTitleFont: Self = .system(.title3, weight: .bold)
    static let eventRoundNumberFont: Self = .body.italic()
    static let liveSessionTitleFont: Self = .body.bold()
    static let chevronRightFont: Self = .body
    static let liveTextFont: Self = .body.bold()

}
