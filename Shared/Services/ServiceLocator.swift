import Combine

final class ServiceLocator {
    
    static let shared = ServiceLocator()
    
    @Published var driverAndConstructorService: DriverAndConstructorServiceRepresentable
    @Published var liveSessionService: LiveSessionServiceRepresentable
    @Published var eventService: EventServiceRepresentable
    
    init(
        driverAndConstructorService: DriverAndConstructorServiceRepresentable = DriverAndConstructorService.make(),
        liveSessionService: LiveSessionServiceRepresentable = LiveSessionService.make(),
        eventService: EventServiceRepresentable = EventService.make()
    ) {
        
        self.driverAndConstructorService = driverAndConstructorService
        self.liveSessionService = liveSessionService
        self.eventService = eventService
    }
}
