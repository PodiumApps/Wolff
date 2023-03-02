import Foundation
import Combine
import OSLog

protocol SessionStandingsListViewModelRepresentable: ObservableObject {

    var state: SessionStandingsListViewModel.State { get }
    var action: PassthroughSubject<SessionStandingsListViewModel.Action, Never> { get }
}

final class SessionStandingsListViewModel: SessionStandingsListViewModelRepresentable {

    @Published var state: SessionStandingsListViewModel.State = .loading
    var action = PassthroughSubject<Action, Never>()
    
    private let drivers: [Driver]
    private let constructors: [Constructor]
    private let liveSessionService: LiveSessionServiceRepresentable
    private var subscriptions = Set<AnyCancellable>()
    private var timer: Timer? = nil
    private var selectedIndex: String? = nil

    init(
        drivers: [Driver],
        constructors: [Constructor],
        liveSessionService: LiveSessionServiceRepresentable = ServiceLocator.shared.liveSessionService
    ) {
        
        self.drivers = drivers
        self.constructors = constructors
        self.liveSessionService = liveSessionService
        
        setupBindings()
    }
    
    // Private
    private func setupBindings() {
        
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .tap(let index):
                    self?.tapRow(at: index)
                case .viewDidLoad:
                    self?.viewDidLoad()
                case .onDisappear:
                    self?.timer?.invalidate()
                }
            }
            .store(in: &subscriptions)
    }

    private func tapRow(at index: Int) {
        
        guard case .results(let positions) = state else {
            return
        }

        for i in 0 ..< positions.count {
            if positions[i].isSelected {
                positions[i].toggleSelection()
            }
        }

        positions[index].toggleSelection()
        selectedIndex = positions[index].driverTicker
        state = .results(positions)
    }
    
    private func viewDidLoad() {
        
        liveSessionService.action.send(.fetchPositions)
        
        liveSessionService.statePublisher
            .receive(on: DispatchQueue.main)
            .map { [weak self] serviceStatus in
                
                guard let self else { return .error }
                
                self.timer?.invalidate()
                
                switch serviceStatus {
                case.error:
                    return .error
                case .refreshing:
                    return .loading
                case .refreshed(let livePositions):
                    self.startUpdating()
                    return self.buildRowsViewModel(for: livePositions)
                }
            }
            .assign(to: &$state)
        
    }
    
    private func startUpdating() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
            guard let self else { return }
            Logger.liveSessionService.info("Refreshing positions list")
            self.liveSessionService.action.send(.updatePositions)
        }
        
    }
    private func buildRowsViewModel(for livePositions: [LivePosition]) -> State {
        
        let standings: [SessionDriverRowViewModel] = livePositions
            .enumerated()
            .compactMap { [weak self] index, position in
            
                guard
                    let self,
                    let driver = self.drivers.lazy.first(where: { $0.driverLiveID == position.id })
                else {
                    return nil
                }
                
            
            return .init(
                    position: position.position,
                    driverTicker: driver.driverThicker,
                    timeGap: position.time,
                    tyrePitCount: position.tyrePitCount,
                    currentTyre: position.tyre,
                    isSelected: driver.driverThicker == self.selectedIndex
                )
        }
        
        return .results(standings)
    }
}

extension SessionStandingsListViewModel {
    
    enum Action {
        
        case tap(Int)
        case viewDidLoad
        case onDisappear
    }
    
    enum State {
        
        case loading
        case results([SessionDriverRowViewModel])
        case error
    }
}
