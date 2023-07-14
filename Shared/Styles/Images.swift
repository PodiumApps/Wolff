import Foundation
import SwiftUI

extension Image {
    
    static let iconTrophy: Self =  Image(systemName: "trophy")
    static let iconFastestLap: Self = Image("fastest_lap_icon")
    
    static let liveSideBarBackground: Self = Image("side_bar")
    static let liveBackground: Self = Image("background")

    static let resultsCardBackground: Self = Image("f1_grid")
    
    static let racingCar: Self = Image("racingCar")
    
    enum TabBar {
        
        static let settings: Image = .init("settings_tab_icon")
        static let season: Image = .init("season_tab_icon")
        static let standings: Image = .init("standings_tab_icon")
    }

    // MARK: - SFSymbols

    static let informationIcon: Self = Image(systemName: "info.circle.fill")
    static let trophyIcon: Self = Image(systemName: "trophy.fill")
    static let chevronRight: Self = Image(systemName: "chevron.right")
}
