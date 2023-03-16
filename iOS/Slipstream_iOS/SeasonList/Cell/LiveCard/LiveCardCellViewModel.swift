import Combine
import Foundation

protocol LiveCardCellViewModelRepresentable: ObservableObject {
    
    var topSection: LiveCardCellViewModel.TopSection { get }
    var cardSection: LiveCardCellViewModel.CardSection { get }
    var time: LiveCardCellViewModel.Time { get }
    var isLive: Bool { get }
    
    
    var action: PassthroughSubject<Void, Never> { get }
}


final class LiveCardCellViewModel: LiveCardCellViewModelRepresentable {
    
    typealias TopSection = (title: String, round: Int)
    typealias CardSection = (title: String, status: String?, drivers: [String])
    typealias Time = (hours: Int, minutes: Int)
    
    @Published var topSection: TopSection
    @Published var cardSection: CardSection
    @Published var time: Time
    var action = PassthroughSubject<Void, Never>()
    
    var isLive: Bool { !cardSection.drivers.isEmpty && time.hours == 0 && time.minutes == 0 }
    
    init(eventDetail: Event.Details, drivers: [Driver]) {
        
        self.topSection = TopSection(title: "", round: 0)
        self.cardSection = CardSection(title: "", status: nil, drivers: [])
        
        self.time = Time(hours: 0, minutes: 0)
        
        setupBindings(eventDetail: eventDetail, drivers: drivers)
        
    }
    
    private func setupBindings(eventDetail: Event.Details, drivers: [Driver]) {
        
        if case .live(let timeInterval, let sessionName, let drivers) = eventDetail.status {
            
            self.topSection = TopSection(title: eventDetail.title, round: eventDetail.round)
            self.cardSection = CardSection(
                title: sessionName,
                status: nil,
                drivers: drivers
            )
            
            if timeInterval < 60 {
                self.time = Time(hours: 0, minutes: 0)
            } else {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute]
                
                let timeString = formatter.string(from: timeInterval) ?? "0:00"
                let timeSplit = timeString.split(separator: ":")
                
                var hours: Int = 0
                
                if timeSplit.count > 1 {
                    hours = Int(timeSplit.first ?? "0") ?? 0
                }
                
                let minutes = Int(timeString.split(separator: ":").last ?? "0")
                
                self.time = Time(hours: hours, minutes: minutes ?? 0)
            }
        }
    }
    
}

extension LiveCardCellViewModel {
    
    enum Action {
        
        case tapLiveEvent
    }
    
    enum State: Equatable {
        
        static func == (lhs: LiveCardCellViewModel.State, rhs: LiveCardCellViewModel.State) -> Bool {
            lhs.id == rhs.id
        }
        
        case results(TopSection, CardSection, Time, isLive: Bool)
        case loading(TopSection, CardSection, Time, isLive: Bool)
        
        enum idValue: String {
            
            case loading
            case results
        }
        
        var id: String {
            
            switch self {
            case .loading: return idValue.loading.rawValue
            case .results: return idValue.results.rawValue
            }
        }
    }
}


extension LiveCardCellViewModel {
    
    static let mockLiveAboutToStart: LiveCardCellViewModel = .init(
        eventDetail: Event.mockDetailsArray[0],
        drivers: Driver.mockArray
    )
}
