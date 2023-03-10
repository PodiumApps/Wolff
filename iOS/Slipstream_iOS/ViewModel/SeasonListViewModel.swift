import Foundation

protocol SeasonListViewModelRepresentable: ObservableObject {
    
    var state: SeasonListViewModel.State { get }
}

class SeasonListViewModel: SeasonListViewModelRepresentable {
    
    private let drivers: [Driver]
    private let constructors: [Constructor]
    private let networkManager: NetworkManagerRepresentable
    
    @Published var state: State
    
    init(
        drivers: [Driver],
        constructors: [Constructor],
        networkManager: NetworkManagerRepresentable
    ) {
        
        self.drivers = drivers
        self.constructors = constructors
        self.networkManager = networkManager
        self.state = .loading
        
        load()
    }
    
    // MARK: - Private
    private func load() {
        
        Task { @MainActor [weak self] in
            
            guard let self else { return }
            
            do {
                let events = try await networkManager.load(Event.getEvents())
                
                let schedulesViewModel: [GrandPrixCardViewModel] = events.map { event in
                    
                    GrandPrixCardViewModel(
                        round: event.round,
                        title: event.name,
                        grandPrixDate: "01-10",
                        eventStatus: event.status
                    )
                }
                
                self.state = .results(schedulesViewModel)
            } catch {
                print(error)
                self.state = .error
            }
        }
    }
}

extension SeasonListViewModel {
    
    enum State {
        
        case error
        case results([GrandPrixCardViewModel])
        case loading
    }
}

extension SeasonListViewModel {
    
    static func make(drivers: [Driver], constructors: [Constructor]) -> SeasonListViewModel {
        
        .init(drivers: drivers, constructors: constructors, networkManager: NetworkManager.shared)
    }
}
