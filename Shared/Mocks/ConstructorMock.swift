import Foundation

extension Constructor {
    
    static let mockFerrari: Self = .init(
        id: UUID().uuidString,
        name: "Ferrari",
        teamPrinciple: "Tomás Mamede",
        standings: .constructorDetail
    )
    static let mockAlfa: Self = .init(
        id: UUID().uuidString,
        name: "Alfa Romeo",
        teamPrinciple: "Miguel Teixeira",
        standings: .constructorDetail
    )
    static let mockMercedes: Self = .init(
        id: UUID().uuidString,
        name: "Mercedes",
        teamPrinciple: "Zé Inácio",
        standings: .constructorDetail
    )
}
