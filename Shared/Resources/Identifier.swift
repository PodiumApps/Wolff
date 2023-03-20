import Foundation

struct Identifier<Value>: Hashable {
    
    let string: String
    
    init(_ value: String) {
        string = value
    }
}

extension Identifier: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        string = try container.decode(String.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
