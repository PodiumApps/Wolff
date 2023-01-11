import Foundation

extension Session {
    
    static let mock: Self = .init(
        id: UUID().uuidString,
        fastestDriver: nil,
        circuit: .mockCircuit,
        round: 23,
        laps: 50,
        date: Date(),
        name: .race,
        timeLeft: nil
    )
}
