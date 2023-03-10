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
    
    private var drivers: [Driver]
    private var constructors: [Constructor]
    private let event: Event
    private let driverAndConstructorService: DriverAndConstructorServiceRepresentable
    private let liveSessionService: LiveSessionServiceRepresentable
    private var subscriptions = Set<AnyCancellable>()
    private var timer: Timer? = nil
    private var viewIsVisible: Bool = false
    @Published private var cells: [Cell]

    init(
        event: Event,
        driverAndConstructorService: DriverAndConstructorServiceRepresentable = ServiceLocator.shared.driverAndConstructorService,
        liveSessionService: LiveSessionServiceRepresentable = ServiceLocator.shared.liveSessionService
    ) {
        
        self.drivers = []
        self.constructors = []
        self.liveSessionService = liveSessionService
        self.driverAndConstructorService = driverAndConstructorService
        self.cells = []
        self.event = event
        
        setupBindings()
    }
    
    // MARK: - Private
    private func setupBindings() {
        
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .tap(let index):
                    self?.tapRow(at: index)
                case .viewDidLoad:
                    self?.viewIsVisible = true
                    self?.startUpdating()
                case .onDisappear:
                    self?.viewIsVisible = false
                    self?.timer?.invalidate()
                case .refresh:
                    self?.liveSessionService.action.send(.fetchPositions)
                }
            }
            .store(in: &subscriptions)
        
        driverAndConstructorService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] driverAndConstructorService in
                
                guard let self else { return }
                
                switch driverAndConstructorService {
                case .refreshed(let drivers, let constructors):
                    self.drivers = drivers
                    self.constructors = constructors
                    self.liveSessionService.action.send(.fetchPositions)
                default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        liveSessionService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] liveSessionService in
                
                guard let self else { return nil }
                
                self.timer?.invalidate()
                
                switch liveSessionService {
                case .error(let error):
                    return .error(error.localizedDescription)
                case .refreshed(let livePositions):
                    return self.buildRowsViewModel(for: livePositions)
                default:
                    return .loading
                }
            }
            .assign(to: &$state)
    }

    private func tapRow(at index: Int) {
        
        guard
            case .results(let cells) = state,
            let positionsIndex = cells.firstIndex(where: { $0.id == Cell.idValue.positionList.rawValue }),
            case .positionList(let positions) = cells[positionsIndex],
            let driver = drivers.lazy.first(where: { $0.driverTicker == positions[index].driverTicker }),
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
        
        self.cells[positionsIndex] = Cell.positionList(positions)
        
        state = .results(cells)
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
                    let driver = drivers.lazy.first(where: { $0.id == position.id }),
                    let constructor = constructors.lazy.first(where: { $0.id == driver.constructorId })
                else {
                    return nil
                }
                
                if selectedDriver == nil, index == 0 {
                    selectedDriver = .init(driver: driver, constructor: constructor)
                }
                
                return .init(
                    position: position.position,
                    driverTicker: driver.driverTicker,
                    timeGap: position.time,
                    tyrePitCount: position.tyrePitCount,
                    currentTyre: position.tyre,
                    constructorId: constructor.id,
                    isSelected: driver.id == self.selectedDriver?.driverID
                )
        }
        
        cells = [.header(event.name), .positionList(standings)]
        
        return .results(cells)
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
        case results([Cell])
        case error(String)
    }
    
    enum Cell: Equatable, Identifiable {
        
        static func == (lhs: SessionStandingsListViewModel.Cell, rhs: SessionStandingsListViewModel.Cell) -> Bool {
            lhs.id == rhs.id
        }
        
        
        case header(String)
        case positionList([SessionDriverRowViewModel])
        
        enum idValue: String {
            case header = "header"
            case positionList = "positionList"
        }
        
        var id: String {
            
            switch self {
            case .header: return idValue.header.rawValue
            case .positionList: return idValue.positionList.rawValue
            }
        }
        
        
    }
}
