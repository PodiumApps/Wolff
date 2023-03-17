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
    
    
    
    
    enum Title {
        static let regular: Font = .system(size: 32)
        static let heavy: Font = .system(size: 32, weight: .heavy)
        static let bold: Font = .system(size: 32, weight: .bold)
        static let semibold: Font = .system(size: 32, weight: .semibold)
    }
    
    enum Title2 {
        static let regular: Font = .system(size: 28)
        static let heavy: Font = .system(size: 28, weight: .heavy)
        static let bold: Font = .system(size: 28, weight: .bold)
        static let semibold: Font = .system(size: 28, weight: .semibold)
    }
    
    enum Title3 {
        static let regular: Font = .system(size: 24)
        static let heavy: Font = .system(size: 24, weight: .heavy)
        static let bold: Font = .system(size: 24, weight: .bold)
        static let semibold: Font = .system(size: 24, weight: .semibold)
    }
    
    enum Title4 {
        static let regular: Font = .system(size: 20)
        static let heavy: Font = .system(size: 20, weight: .heavy)
        static let bold: Font = .system(size: 20, weight: .bold)
        static let semibold: Font = .system(size: 20, weight: .semibold)
    }
    
    enum Body {
        static let regular: Font = .system(size: 16)
        static let heavy: Font = .system(size: 16, weight: .heavy)
        static let bold: Font = .system(size: 16, weight: .bold)
        static let semibold: Font = .system(size: 16, weight: .semibold)
    }
    
    enum Caption {
        static let regular: Font = .system(size: 12)
        static let heavy: Font = .system(size: 12, weight: .heavy)
        static let bold: Font = .system(size: 12, weight: .bold)
        static let semibold: Font = .system(size: 12, weight: .semibold)
    }
    
    enum Superscript {
        static let regular: Font = .system(size: 8)
        static let heavy: Font = .system(size: 8, weight: .heavy)
        static let bold: Font = .system(size: 8, weight: .bold)
        static let semibold: Font = .system(size: 8, weight: .semibold)
    }

}
