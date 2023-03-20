import Foundation

protocol StandingsCellViewModelRepresentable {
    
    var titleRegular: String { get }
    var titleBold: String { get }
    var circleText: String { get }
    var detailsText: String { get }
    var points: Int { get }
    var position: Int { get }
    
    var constructorStylerID: Constructor.ID { get }
    var driverID: Driver.ID { get }
}

class StandingsCellViewModel: StandingsCellViewModelRepresentable {
    
    let titleRegular: String
    let titleBold: String
    let circleText: String
    let detailsText: String
    let points: Int
    let position: Int
    let constructorStylerID: Constructor.ID
    let driverID: Driver.ID
    
    init(driver: Driver, constructor: [Constructor]) {
        
        guard let constructor = constructor.lazy.first(where: { $0.id == driver.constructorId }) else {
            fatalError("Drivers should have constructors!")
        }
        
        self.titleRegular = driver.firstName
        self.titleBold = driver.lastName.uppercased()
        self.circleText = "\(driver.carNumber)"
        self.detailsText = constructor.fullName
        self.points = driver.points
        self.position = driver.position
        
        self.constructorStylerID = constructor.id
        self.driverID = driver.id
    }
}

extension StandingsCellViewModel {
    
    static var mock: StandingsCellViewModel = .init(driver: .mockVertasppen, constructor: [.mockMercedes])
}
