import Foundation
import Combine

protocol UpcomingAndStandingsEventCellViewModelRepresentable: ObservableObject {
    
    var cells: [UpcomingAndStandingsEventCellViewModel.Cell] { get }
    var filters: [UpcomingAndStandingsEventCellViewModel.Filter] { get }
    var filterSelection: UpcomingAndStandingsEventCellViewModel.Filter { get }
    
    var action: PassthroughSubject<UpcomingAndStandingsEventCellViewModel.Action, Never> { get }
}

class UpcomingAndStandingsEventCellViewModel: UpcomingAndStandingsEventCellViewModelRepresentable {
    
    @Published var cells: [Cell]
    
    let filters: [Filter] = Filter.allCases
    @Published var filterSelection: Filter = .upcoming
    
    private var upcomingEvents: [GrandPrixCardViewModel]
    private var finishedEvents: [GrandPrixCardViewModel]
    private var subscriptions = Set<AnyCancellable>()
    private let eventDetails: [Event.ShortDetails]
    
    var action = PassthroughSubject<Action, Never>()
    
    init(eventDetails: [Event.ShortDetails], drivers: [Driver], constructors: [Constructor], filter: Filter) {
        
        self.cells = []
        self.upcomingEvents = []
        self.finishedEvents = []
        self.eventDetails = eventDetails
        self.filterSelection = filter
        
        loadEventDetails(drivers: drivers)
        setupBindings(drivers: drivers, constructors: constructors)
    }
    
    private func setupBindings(drivers: [Driver], constructors: [Constructor]) {
        
        self.cells = [
            .upcoming(filterSelection == .upcoming ? self.upcomingEvents : self.finishedEvents),
            .standings(drivers, constructors)
        ]
        
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                
                guard let self else { return }
                
                switch action {
                case .filterEvent(let filter):
                    self.filterSelection = filter
                    self.buildUpcomingViewModel(for: filter == .upcoming ? self.upcomingEvents : self.finishedEvents)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func loadEventDetails(drivers: [Driver]) {
        
        eventDetails.lazy.forEach { details in
            
            switch details.status {
            case .upcoming(let start, let end, let session, let timeInterval):
                
                self.upcomingEvents.append(
                        .init(
                        round: details.round,
                        title: details.title,
                        subtitle: details.country,
                        grandPrixDate: timeInterval ?? .threeDaysInterval  < .threeDaysInterval
                            ? session
                            : start + " - " + end,
                        winners: [],
                        nextSession: timeInterval
                    )
                )
                
            case .finished(let winners):
                let winnersTickers: [String] = winners.lazy.enumerated().compactMap { index, winner in
                    
                    guard let driver = drivers.lazy.first(where: { $0.id == winner }) else { return nil }
                    return driver.driverTicker
                }
                
                self.finishedEvents.append(
                    GrandPrixCardViewModel(
                        round: details.round,
                        title: details.title,
                        subtitle: details.country,
                        grandPrixDate: "",
                        winners: winnersTickers,
                        nextSession: nil
                    )
                )
            case .live:
                break
            }
        }
    }
    
    
    private func buildUpcomingViewModel(for events: [GrandPrixCardViewModel]) {
        
        if let index = cells.firstIndex(where: { $0.id == .upcoming }) {
            
            cells[index] = .upcoming(events)
        }
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
        
        enum Identifier {
            case upcoming
            case standings
        }
        
        var id: Identifier {
            
            switch self {
            case .upcoming: return .upcoming
            case .standings: return .standings
            }
        }
    }
    
    enum Filter: CaseIterable, Hashable, Identifiable {
        
        case upcoming
        case past
        
        var label: String {
            switch self {
            case .upcoming: return Localization.UpcomingAndStandingsCell.Segment.upcoming
            case .past: return Localization.UpcomingAndStandingsCell.Segment.past
            }
        }
        
        var id: Self { return self }
    }
    
    enum Action {
        
        case filterEvent(Filter)
    }
}
