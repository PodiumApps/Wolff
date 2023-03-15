import Foundation
import Combine

protocol UpcomingAndStandingsEventCellViewModelRepresentable: ObservableObject {
    
    var cells: [UpcomingAndStandingsEventCellViewModel.Cell] { get }
    
}

class UpcomingAndStandingsEventCellViewModel: UpcomingAndStandingsEventCellViewModelRepresentable {
    
    @Published var cells: [Cell]
    
    init(upcoming: [GrandPrixCardViewModel], drivers: [Driver], constructors: [Constructor]) {
        
        cells = [
            .upcoming(upcoming),
            .standings(drivers, constructors)
        ]
    }
    
}

extension UpcomingAndStandingsEventCellViewModel {
    
    enum Cell: Hashable, Identifiable {
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        case upcoming([GrandPrixCardViewModel])
        case standings([Driver], [Constructor])
        
        enum idValue: String {
            case upcoming = "upcoming"
            case standings = "standings"
        }
        
        var id: String {
            
            switch self {
            case .upcoming: return idValue.upcoming.rawValue
            case .standings: return idValue.standings.rawValue
            }
        }
    }
    
    enum UpcomingOrPastFilter: CaseIterable, Hashable, Identifiable {
        
        case upcoming
        case past
        
        var label: String {
            switch self {
            case .upcoming: return "Upcoming"
            case .past: return "Past"
            }
        }
        
        var id: Self { return self }
    }
}
