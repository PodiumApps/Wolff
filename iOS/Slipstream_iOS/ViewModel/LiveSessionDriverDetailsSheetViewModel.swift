import Foundation

protocol LiveSessionDriverDetailsSheetViewModelRepresentable: ObservableObject {
    
    var titleRegular: String { get }
    var titleBold: String { get }
    var circleText: String { get }
    var detailsText: String { get }
    
    var constructorStylerID: String { get }
    var driverID: Int { get }
}

class LiveSessionDriverDetailsSheetViewModel: LiveSessionDriverDetailsSheetViewModelRepresentable {
    
    let titleRegular: String
    let titleBold: String
    let circleText: String
    let detailsText: String
    let constructorStylerID: String
    let driverID: Int
    
    init(driver: Driver, constructor: Constructor) {
        
        self.titleRegular = driver.firstName
        self.titleBold = driver.lastName.uppercased()
        self.circleText = "\(driver.carNumber)"
        self.detailsText = constructor.name
        
        self.constructorStylerID = constructor.constructorId
        self.driverID = driver.id
    }
}
