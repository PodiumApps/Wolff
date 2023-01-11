import Foundation

extension Driver {
    
    static let mockVertasppen: Self = .init(
        id: UUID().uuidString,
        carNumber: 27,
        codeName: "VER",
        name: "Marc Verstappen",
        birth: Date(),
        constructor: .mockFerrari,
        standings: .driverDetail
    )
    
    static let mockLeclerc: Self = .init(
        id: UUID().uuidString,
        carNumber: 21,
        codeName: "LEC",
        name: "Mr Leclerc",
        birth: Date(),
        constructor: .mockFerrari,
        standings: .driverDetail
    )
    
    static let mockAlonso: Self = .init(
        id: UUID().uuidString,
        carNumber: 21,
        codeName: "ALO",
        name: "Alonso",
        birth: Date(),
        constructor: .mockAlfa,
        standings: .driverDetail
    )
    
    static let mockHamilton: Self = .init(
        id: UUID().uuidString,
        carNumber: 12,
        codeName: "HAM",
        name: "Lewis Hamilton",
        birth: Date(),
        constructor: .mockMercedes,
        standings: .driverDetail
    )
}
