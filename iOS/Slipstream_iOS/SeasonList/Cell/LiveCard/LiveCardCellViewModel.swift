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
    typealias Time = (hours: Int, minutes: Int, seconds: Int)
    
    @Published var topSection: TopSection
    @Published var cardSection: CardSection
    @Published var time: Time
    var action = PassthroughSubject<Void, Never>()
    
    var isLive: Bool { !cardSection.drivers.isEmpty && time.hours == 0 && time.minutes == 0 }
    
    init(eventDetail: Event.ShortDetails, drivers: [Driver]) {
        
        self.topSection = TopSection(title: "", round: 0)
        self.cardSection = CardSection(title: "", status: nil, drivers: [])
        
        self.time = Time(hours: 0, minutes: 0, seconds: 0)
        
        setupBindings(eventDetail: eventDetail, drivers: drivers)
        
    }
    
    private func setupBindings(eventDetail: Event.ShortDetails, drivers: [Driver]) {
        
        let driverTickers: [String] = drivers.map(\.driverTicker)
        
        if case .live(let timeInterval, let sessionName) = eventDetail.status {
            
            self.topSection = TopSection(title: eventDetail.title, round: eventDetail.round)
            self.cardSection = CardSection(
                title: sessionName,
                status: nil,
                drivers: driverTickers
            )
            
            if timeInterval < 60 {
                self.time = Time(hours: 0, minutes: 0, seconds: 0)
            } else {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = timeInterval < .hourInterval ? [.minute, .second] : [.hour, .minute]
                
                let timeString = formatter.string(from: timeInterval) ?? "0:00"
                let timeSplit = timeString.split(separator: ":")
                
                let hours: Int
                let minutes: Int
                let seconds: Int
                
                if timeInterval < .hourInterval {
                    hours = 0
                    minutes = Int(timeSplit.first ?? "0") ?? 0
                    seconds = Int(timeString.split(separator: ":").last ?? "0") ?? 0
                } else {
                    hours = timeSplit.count > 1 ? Int(timeSplit.first ?? "0") ?? 0 : 0
                    minutes = Int(timeString.split(separator: ":").last ?? "0") ?? 0
                    seconds = 0
                }
                
                self.time = Time(hours: hours, minutes: minutes, seconds: seconds)
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
        
        enum Identifier {
            
            case loading
            case results
        }
        
        var id: Identifier {
            
            switch self {
            case .loading: return .loading
            case .results: return .results
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
