import SwiftUI

extension Color {

    enum Constructor {

        static let alphaRomeo: Color = .init("alphaRomeo")
        static let alphaTauri: Color = .init("alphaTauri")
        static let alpine: Color = .init("alpine")
        static let astonMartin: Color = .init("astonMartin")
        static let ferrari: Color = .init("ferrari")
        static let haas: Color = .init("haas")
        static let mclaren: Color = .init("mclaren")
        static let mercedes: Color = .init("mercedes")
        static let redBull: Color = .init("redBull")
        static let williams: Color = .init("williams")
        static let noTeam: Color = .primary
    }

    enum Event {

        static let completedOrUpcomingEvent: Color = .init("completedOrUpcoming")
        static let liveSession: Color = .init("live")
        static let current: Color = .init("current")
    }

    enum SessionDriverRow {

        static let positionBackground: Color = .init("positionBackground")
        static let rowBackground: Color = .init("rowBackground")
        static let firstPlaceTime: Color = .init("firstPlaceTime")
        static let secondPlaceTime: Color = .init("secondPlaceTime")
    }

    enum Tyre {

        static let soft: Color = .init("soft")
        static let medium: Color = .init("medium")
        static let hard: Color = .init("hard")
        static let wet: Color = .init("wet")
        static let intermediate: Color = .init("intermediate")
    }
}
