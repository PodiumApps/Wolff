import Foundation

protocol NewsCarouselComponentRepresentable {

    var driverName: String { get }
    var constructorName: String { get }
    var position: Int { get }
    var points: Int { get }
}

final class NewsCarouselComponentViewModel: NewsCarouselComponentRepresentable {

    let driverName: String
    let constructorName: String
    let position: Int
    let points: Int

    init(driverName: String, constructorName: String, position: Int, points: Int) {

        self.driverName = driverName
        self.constructorName = constructorName
        self.position = position
        self.points = points
    }
}
