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
            id: 0,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        ),
        .init(
            id: 1,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        ),
        .init(
            id: 2,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        ),
        .init(
            id: 3,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        ),
        .init(
            id: 4,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        ),
        .init(
            id: 5,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        ),
        .init(
            id: 6,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        ),
        .init(
            id: 7,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        ),
        .init(
            id: 8,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        ),
        .init(
            id: 9,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        ),
        .init(
            id: 10,
            laps: 52,
            date: Date(),
            name: .race,
            winnerID: "lewis_hamilton"
        )
    ]
}
