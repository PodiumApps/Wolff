import Combine

final class ServiceLocator {
    
    static let shared = ServiceLocator()
    
    @Published var driverAndConstructorService: DriverAndConstructorServiceRepresentable
    @Published var liveSessionService: LiveSessionServiceRepresentable
    @Published var eventService: EventServiceRepresentable
    @Published var newsService: NewsServiceRepresentable
    
    init(
        driverAndConstructorService: DriverAndConstructorServiceRepresentable = DriverAndConstructorService.make(),
        liveSessionService: LiveSessionServiceRepresentable = LiveSessionService.make(),
        eventService: EventServiceRepresentable = EventService.make(),
        newsService: NewsServiceRepresentable = NewsService.make()
    ) {
        
        self.driverAndConstructorService = driverAndConstructorService
        self.liveSessionService = liveSessionService
        self.eventService = eventService
        self.newsService = newsService
    }
}
