import Foundation
import Combine
import OSLog

protocol SessionStandingsListViewModelRepresentable: ObservableObject {

    var state: SessionStandingsListViewModel.State { get }
    var action: PassthroughSubject<SessionStandingsListViewModel.Action, Never> { get }
    var selectedDriver: LiveSessionDriverDetailsSheetViewModel? { get }
}

final class SessionStandingsListViewModel: SessionStandingsListViewModelRepresentable {

    @Published var state: SessionStandingsListViewModel.State = .loading
    @Published var selectedDriver: LiveSessionDriverDetailsSheetViewModel? = nil
    var action = PassthroughSubject<Action, Never>()
    
    private let drivers: [Driver]
    private let constructors: [Constructor]
    private let liveSessionService: LiveSessionServiceRepresentable
    private var subscriptions = Set<AnyCancellable>()
    private var timer: Timer? = nil
    private var viewIsVisible: Bool = false

    init(
        drivers: [Driver],
        constructors: [Constructor],
        liveSessionService: LiveSessionServiceRepresentable = ServiceLocator.shared.liveSessionService
    ) {
        
        self.drivers = drivers
        self.constructors = constructors
        self.liveSessionService = liveSessionService
        
        liveSessionService.action.send(.fetchPositions)
        
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
                    self?.viewIsVisible = true
                    self?.liveSessionService.action.send(.updatePositions)
                case .onDisappear:
                    self?.viewIsVisible = false
                    self?.timer?.invalidate()
                case .refresh:
                    self?.liveSessionService.action.send(.fetchPositions)
                }
            }
            .store(in: &subscriptions)
        
        
        liveSessionService.statePublisher
            .receive(on: DispatchQueue.main)
            .map { [weak self] serviceStatus in
                
                guard let self else { return .error("Missing self") }
                
                self.timer?.invalidate()
                
                switch serviceStatus {
                case.error(let error):
                    return .error(error.localizedDescription)
                case .refreshing:
                    return .loading
                case .refreshed(let livePositions):
                    self.startUpdating()
                    return self.buildRowsViewModel(for: livePositions)
                }
            }
            .assign(to: &$state)
    }

    private func tapRow(at index: Int) {
        
        guard
            case .results(let positions) = state,
            let driver = drivers.lazy.first(where: { $0.driverThicker == positions[index].driverTicker }),
            let constructor = constructors.lazy.first(where: { $0.id == driver.constructorId })
        else {
            return
        }

        for i in 0 ..< positions.count {
            if positions[i].isSelected {
                positions[i].toggleSelection()
            }
        }

        positions[index].toggleSelection()
        
        selectedDriver = .init(driver: driver, constructor: constructor)
        
        state = .results(positions)
    }
    
    private func startUpdating() {
        
        guard viewIsVisible else { return }
        
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
                    let driver = drivers.lazy.first(where: { $0.driverLiveID == position.id }),
                    let constructor = constructors.lazy.first(where: { $0.id == driver.constructorId })
                else {
                    return nil
                }
                
                if selectedDriver == nil, index == 0 {
                    selectedDriver = .init(driver: driver, constructor: constructor)
                }
                
                
                return .init(
                    position: position.position,
                    driverTicker: driver.driverThicker,
                    timeGap: position.time,
                    tyrePitCount: position.tyrePitCount,
                    currentTyre: position.tyre,
                    constructorId: constructor.constructorId,
                    isSelected: driver.driverThicker == self.selectedDriver?.driver.driverThicker
                )
        }
        
        return .results(standings)
    }
}

extension SessionStandingsListViewModel {
    
    enum Action {
        
        case tap(Int)
        case refresh
        case viewDidLoad
        case onDisappear
    }
    
    enum State {
        
        case loading
        case results([SessionDriverRowViewModel])
        case error(String)
    }
}
