import Foundation

enum NetworkError: Error {
    case invalidResponse(statusCode: Int, String)
    case badUrl(URL?)
    case decodingError(Error?)
    case noComponents
    case badResponse(URLResponse?)
    case encodingError(Error)
}

enum HttpMethod {
    
    case get([URLQueryItem] = [], accessToken: String? = nil)
    case post(body: Encodable, accessToken: String? = nil)

    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

struct Resource<T: Decodable> {

    let url: URL
    var method: HttpMethod
}

protocol NetworkManagerRepresentable {
    
    func load<T: Decodable>(_ resource: Resource<T>) async throws -> T
}
