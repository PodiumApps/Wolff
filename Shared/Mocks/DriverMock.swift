import Foundation

extension Driver {
    
    static let mockVertasppen: Self = .init(
        id: 0,
        driverLiveID: "max_verstappen",
        firstName: "Max",
        lastName: "Verstappen",
        driverThicker: "VER",
        position: 1,
        points: 10,
        constructorId: 0
    )
    
    static let mockLeclerc: Self = .init(
        id: 1,
        driverLiveID: "leclerc",
        firstName: "Max",
        lastName: "Leclerc",
        driverThicker: "LEC",
        position: 2,
        points: 10,
        constructorId: 1
    )
    
    
    static let mockAlonso: Self = .init(
        id: 2,
        driverLiveID: "fernando_alonso",
        firstName: "Fernando",
        lastName: "Alonso",
        driverThicker: "ALO",
        position: 3,
        points: 10,
        constructorId: 2
    )
    
    
    static let mockHamilton: Self = .init(
        id: 3,
        driverLiveID: "lewis_hamilton",
        firstName: "Lewis",
        lastName: "Hamilton",
        driverThicker: "HAM",
        position: 4,
        points: 10,
        constructorId: 2
    )
    
}
