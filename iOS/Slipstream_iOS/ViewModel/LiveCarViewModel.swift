import Foundation


protocol LiveCarRepresentable {
    
    var image: String { get }
    var position: Int { get }
    var label: String { get }
    var offset: CGFloat { get }
    var time: Double { get }
}

final class LiveCarViewModel: LiveCarRepresentable {
    
    let image: String
    let position: Int
    let label: String
    let offset: CGFloat
    let time: Double
    
    init(image: String, position: Int, label: String, offset: CGFloat, time: Double) {
        
        self.image = image
        self.position = position
        self.label = label
        self.offset = offset
        self.time = time
    }
    
}
