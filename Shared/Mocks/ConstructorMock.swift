import Foundation

extension Constructor {
    
    static let mockFerrari: Self = .init(
        id: .init("ferrari"),
        name: "Ferrari",
        fullName: "Oi",
        teamPrinciple: "tEamy",
        position: 1,
        points: 0
    )
    
    static let mockRedBull: Self = .init(
        id: .init("red_bull"),
        name: "Red bull",
        fullName: "Red Bull Racing",
        teamPrinciple: "tEamy",
        position: 1,
        points: 0
    )
    
    static let mockAlfa: Self = .init(
        id: .init("alfa"),
        name: "Alfa",
        fullName: "Oi",
        teamPrinciple: "tEamy",
        position: 1,
        points: 0
    )
    
    static let mockAston: Self = .init(
        id: .init("aston_martin"),
        name: "Aston",
        fullName: "Oi",
        teamPrinciple: "tEamy",
        position: 1,
        points: 0
    )
    
    static let mockMercedes: Self = .init(
        id: .init("mercedes"),
        name: "Mercedes",
        fullName: "Oi",
        teamPrinciple: "tEamy",
        position: 1,
        points: 0
    )
    
    static let mockArray: [Self] = [.mockAlfa, .mockFerrari, .mockMercedes, .mockAston, .mockRedBull]
}
