import Foundation

protocol ConstructorStandingsCellViewModelRepresentable: Identifiable, ObservableObject {

    var constructorID: Constructor.ID { get }
    var name: String { get }
    var fullName: String { get }
    var teamPrinciple: String { get }
    var points: Int { get }
    var position: Int { get }
}

final class ConstructorStandingsCellViewModel: ConstructorStandingsCellViewModelRepresentable {

    var constructorID: Constructor.ID
    var name: String
    var fullName: String
    var teamPrinciple: String
    var points: Int
    var position: Int

    init(constructor: Constructor, position: Int) {

        self.constructorID = constructor.id
        self.name = constructor.name
        self.fullName = constructor.fullName
        self.teamPrinciple = constructor.teamPrinciple
        self.points = constructor.points
        self.position = position
    }
}


