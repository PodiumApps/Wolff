import Foundation

protocol SeasonListViewModelRepresentable: ObservableObject {
    
}

class SeasonListViewModel: SeasonListViewModelRepresentable {
    
    private let drivers: [Driver]
    private let constructors: [Constructor]
    
    init(drivers: [Driver], constructors: [Constructor]) {
        
        self.drivers = drivers
        self.constructors = constructors
    }
}
