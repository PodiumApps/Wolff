import Foundation


extension SessionResult {
    
    static let mock: [Self] = [
        .init(
            id: UUID().uuidString,
            driver: .mockVertasppen,
            points: 40,
            tirePitCount: 3,
            startingGrid: 1,
            session: .mock,
            tireName: .hard,
            position: 1,
            time: 0,
            lap: 23
        ),
        .init(
            id: UUID().uuidString,
            driver: .mockAlonso,
            points: 20,
            tirePitCount: 3,
            startingGrid: 1,
            session: .mock,
            tireName: .soft,
            position: 2,
            time: 5.231,
            lap: 23
        ),
        .init(
            id: UUID().uuidString,
            driver: .mockHamilton,
            points: 40,
            tirePitCount: 3,
            startingGrid: 1,
            session: .mock,
            tireName: .medium,
            position: 3,
            time: 4.231,
            lap: 23
        ),
        .init(
            id: UUID().uuidString,
            driver: .mockLeclerc,
            points: 40,
            tirePitCount: 6,
            startingGrid: 1,
            session: .mock,
            tireName: .medium,
            position: 4,
            time: 6.131,
            lap: 23
        )
    ]
}
