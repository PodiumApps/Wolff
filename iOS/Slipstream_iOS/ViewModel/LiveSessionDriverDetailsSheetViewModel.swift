import Foundation

protocol LiveSessionDriverDetailsSheetViewModelRepresentable: ObservableObject {
    
    var titleRegular: String { get }
    var titleBold: String { get }
    var circleText: String { get }
    var detailsText: String { get }
    
    var constructorStylerID: Constructor.ID { get }
    var driverID: Driver.ID { get }
}

class LiveSessionDriverDetailsSheetViewModel: LiveSessionDriverDetailsSheetViewModelRepresentable {
    
    let titleRegular: String
    let titleBold: String
    let circleText: String
    let detailsText: String
    let constructorStylerID: Constructor.ID
    let driverID: Driver.ID
    
    init(driver: Driver, constructor: Constructor) {
        
        self.titleRegular = driver.firstName
        self.titleBold = driver.lastName.uppercased()
        self.circleText = "\(driver.carNumber)"
        self.detailsText = constructor.name
        
        self.constructorStylerID = constructor.id
        self.driverID = driver.id
    }
}
