import Foundation
import Combine

protocol ConstructorStandingsCellViewModelRepresentable: Identifiable, ObservableObject {

    var constructorID: Constructor.ID { get }
    var name: String { get }
    var fullName: String { get }
    var teamPrinciple: String { get }
    var points: Int { get }
    var position: Int { get }
    var showConstructorDetailsSheet: Bool { get set }
    var action: PassthroughSubject<ConstructorStandingsCellViewModel.Action, Never> { get }
}

final class ConstructorStandingsCellViewModel: ConstructorStandingsCellViewModelRepresentable {

    var constructorID: Constructor.ID
    var name: String
    var fullName: String
    var teamPrinciple: String
    var points: Int
    var position: Int

    @Published var showConstructorDetailsSheet: Bool = false

    var action = PassthroughSubject<ConstructorStandingsCellViewModel.Action, Never>()
    private var subscribers = Set<AnyCancellable>()

    init(constructor: Constructor, position: Int) {

        self.constructorID = constructor.id
        self.name = constructor.name
        self.fullName = constructor.fullName
        self.teamPrinciple = constructor.teamPrinciple
        self.points = constructor.points
        self.position = position

        self.setUpBindings()
    }

    private func setUpBindings() {

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .openDetailsView:
                    showConstructorDetailsSheet = true
                }
            }
            .store(in: &subscribers)
    }
}

extension ConstructorStandingsCellViewModel {

    enum Action {

        case openDetailsView
    }
}


