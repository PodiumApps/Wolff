import Foundation

extension Session {

    static let mock: Self = .init(
        id: "race",
        laps: 52,
        date: Date(),
        name: .race,
        winnerID: "lewis_hamilton"
    )
}
