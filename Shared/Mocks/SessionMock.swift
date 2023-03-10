import Foundation

extension Session {

    static let mock: Self = .init(
        id: .init("0"),
        laps: 52,
        date: Date(),
        name: .race,
        winnerID: .init("lewis_hamilton")
    )
    
    static let mockArray: [Self] = [
        .init(
            id: .init("0"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        ),
        .init(
            id: .init("1"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        ),
        .init(
            id: .init("2"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        ),
        .init(
            id: .init("3"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        ),
        .init(
            id: .init("4"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        ),
        .init(
            id: .init("5"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        ),
        .init(
            id: .init("6"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        ),
        .init(
            id: .init("7"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        ),
        .init(
            id: .init("8"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        ),
        .init(
            id: .init("9"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        ),
        .init(
            id: .init("10"),
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: .init("lewis_hamilton")
        )
    ]
}
