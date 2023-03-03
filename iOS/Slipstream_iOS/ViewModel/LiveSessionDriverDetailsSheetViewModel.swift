import Foundation

protocol LiveSessionDriverDetailsSheetViewModelRepresentable: ObservableObject {
    
    var driver: Driver { get }
    var constructor: Constructor { get }
}

class LiveSessionDriverDetailsSheetViewModel: LiveSessionDriverDetailsSheetViewModelRepresentable {
    
    let driver: Driver
    let constructor: Constructor
    
    init(driver: Driver, constructor: Constructor) {
        
        self.driver = driver
        self.constructor = constructor
    }
}
