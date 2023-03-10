import Foundation

extension Driver {
    
    static let mockVertasppen: Self = .init(
        id: .init("max_verstappen_mocking"),
        carNumber: 10,
        firstName: "Max",
        lastName: "Verstappen",
        driverTicker: "VER",
        position: 1,
        points: 10,
        constructorId: .init("red_bull")
    )
    
    static let mockLeclerc: Self = .init(
        id: .init("leclerc"),
        carNumber: 12,
        firstName: "Max",
        lastName: "Leclerc",
        driverTicker: "LEC",
        position: 2,
        points: 10,
        constructorId: .init("ferrari")
    )
    
    
    static let mockAlonso: Self = .init(
        id: .init("fernando_alonso"),
        carNumber: 20,
        firstName: "Fernando",
        lastName: "Alonso",
        driverTicker: "ALO",
        position: 3,
        points: 10,
        constructorId: .init("aston_martin")
    )
    
    
    static let mockHamilton: Self = .init(
        id: .init("lewis_hamilton"),
        carNumber: 30,
        firstName: "Lewis",
        lastName: "Hamilton",
        driverTicker: "HAM",
        position: 4,
        points: 10,
        constructorId: .init("mercedes")
    )
    
}
