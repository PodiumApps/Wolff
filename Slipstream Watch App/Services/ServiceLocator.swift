import Combine

final class ServiceLocator {
    
    static let shared = ServiceLocator()
    
    @Published var driverAndConstructorService: DriverAndConstructorServiceRepresentable
    @Published var liveSessionService: LiveSessionServiceRepresentable
    @Published var eventService: EventServiceRepresentable
    @Published var purchaseService: PurchaseServiceRepresentable
    @Published var newsService: NewsServiceRepresentable
    @Published var notificationService: NotificationServiceRepresentable
    
    init(
        driverAndConstructorService: DriverAndConstructorServiceRepresentable = DriverAndConstructorService.make(),
        liveSessionService: LiveSessionServiceRepresentable = LiveSessionService.make(),
        eventService: EventServiceRepresentable = EventService.make(),
        purchaseService: PurchaseServiceRepresentable = PurchaseService.make(),
        newsService: NewsServiceRepresentable = NewsService.make(),
        notificationService: NotificationServiceRepresentable = NotificationService.make()
    ) {
        
        self.driverAndConstructorService = driverAndConstructorService
        self.liveSessionService = liveSessionService
        self.eventService = eventService
        self.purchaseService = purchaseService
        self.newsService = newsService
        self.notificationService = notificationService
    }
}
