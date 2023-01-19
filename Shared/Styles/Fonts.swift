import SwiftUI

extension Font {

    static let subheadlineFont: Self = Font.subheadline
    static let titleFontBold: Self = Font.system(.title2, weight: .bold)

    static let newsCarouselPositionFont: Self = Font.system(size: 45, weight: .bold)
    static let newsCarouselDriverNameFont: Self = Font.headline
    static let newsCarouselConstrutorNameFont: Self = Font.subheadline.italic()

    static let eventTitleFont: Self = Font.system(.title3, weight: .bold)
    static let eventRoundNumberFont: Self = Font.body.italic()
    static let liveSessionTitleFont: Self = Font.body.bold()
    static let chevronRightFont: Self = Font.largeTitle
    static let liveTextFont: Self = Font.body.bold()

}
