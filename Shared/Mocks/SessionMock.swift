import Foundation

extension Session {

    static let mock: Self = .init(
        id: .init("0"),
        laps: 52,
        date: Date(),
        name: .race,
        winnerID: .init("lewis_hamilton")
    )
}
