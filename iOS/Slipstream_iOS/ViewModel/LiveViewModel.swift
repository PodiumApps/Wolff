import SwiftUI

protocol LiveViewModelRepresentable: ObservableObject {
    
    var topSection: LiveViewModel.TopSection { get }
    var cardSection: LiveViewModel.CardSection { get }
    var time: LiveViewModel.Time { get }
    var isLive: Bool { get }
    
//    var state: LiveViewModel.State { get }
}


final class LiveViewModel: LiveViewModelRepresentable {
    
    typealias TopSection = (title: String, round: Int)
    typealias CardSection = (title: String, status: String?, drivers: [String])
    typealias Time = (hours: Int, minutes: Int)
    
    let topSection: TopSection
    let cardSection: CardSection
    let time: Time
    
    var isLive: Bool { !cardSection.drivers.isEmpty && time.hours == 0 && time.minutes == 0 }
    
    init(topSection: TopSection, cardSection: CardSection, timeInterval: TimeInterval) {
        
        self.topSection = topSection
        self.cardSection = cardSection
        
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

extension LiveViewModel {
    
    enum State: Equatable {
        
        static func == (lhs: LiveViewModel.State, rhs: LiveViewModel.State) -> Bool {
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


extension LiveViewModel {
    
    static let mockLiveAboutToStart: LiveViewModel = .init(
        topSection: TopSection(title: "Emilia Romagna, Italy", round: 23),
        cardSection: CardSection(title: "Race", status: "", drivers: []),
        timeInterval: .init(0)
    )
    
    static let mockLiveSoon: LiveViewModel = .init(
        topSection: TopSection(title: "Emilia Romagna, Italy", round: 23),
        cardSection: CardSection(title: "Race", status: "", drivers: []),
        timeInterval: .init(400)
    )
    
    static let mockLiveSoonHours: LiveViewModel = .init(
        topSection: TopSection(title: "Emilia Romagna, Italy", round: 23),
        cardSection: CardSection(title: "Race", status: "", drivers: []),
        timeInterval: .init(4300)
    )
    
    static let mockLive: LiveViewModel = .init(
        topSection: TopSection(title: "Emilia Romagna, Italy", round: 23),
        cardSection: CardSection(
            title: "Race",
            status: "Lap 14/28",
            drivers: [
                Driver.mockHamilton.driverTicker,
                Driver.mockVertasppen.driverTicker,
                Driver.mockAlonso.driverTicker
            ]
        ),
        timeInterval: .init(0)
    )
}
