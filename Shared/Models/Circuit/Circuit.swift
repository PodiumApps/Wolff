import Foundation

struct Circuit: Decodable, Identifiable,Hashable {

    let id: String
    let name: String
    let location: Location
    let image: String
    let lenght: Double
    let fastestLapTime: String
    
    static let mockCircuit: Self = .init(
        id: UUID().uuidString,
        name: "Imola",
        location: .init(lat: 123.1231, long: 12.1232),
        image: "imola.svg",
        lenght: 340.39,
        fastestLapTime: "1:30:204"
    )
}

extension Circuit {
    struct Location: Decodable, Hashable {
        
        // Seria fixe ter uma map view com um pin no local do circuito e um botão para
        // abrir a app dos maps com direções para lá 😍
        let lat: Double
        let long: Double
    }
}
