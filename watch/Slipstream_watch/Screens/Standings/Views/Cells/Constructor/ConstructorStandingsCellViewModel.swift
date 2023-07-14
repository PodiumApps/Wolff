import Foundation
import Combine

protocol ConstructorStandingsCellViewModelRepresentable: Identifiable, ObservableObject {

    var constructorID: Constructor.ID { get }
    var name: String { get }
    var fullName: String { get }
    var teamPrinciple: String { get }
    var points: Int { get }
    var position: Int { get }
    var action: PassthroughSubject<ConstructorStandingsCellViewModel.Action, Never> { get }
}

final class ConstructorStandingsCellViewModel: ConstructorStandingsCellViewModelRepresentable {

    var constructorID: Constructor.ID
    var name: String
    var fullName: String
    var teamPrinciple: String
    var points: Int
    var position: Int

    var action = PassthroughSubject<ConstructorStandingsCellViewModel.Action, Never>()

    init(constructor: Constructor, position: Int) {

        self.constructorID = constructor.id
        self.name = constructor.name
        self.fullName = constructor.fullName
        self.teamPrinciple = constructor.teamPrinciple
        self.points = constructor.points
        self.position = position
    }
}

extension ConstructorStandingsCellViewModel {

    enum Action {

        case openDetailsView
    }
}


