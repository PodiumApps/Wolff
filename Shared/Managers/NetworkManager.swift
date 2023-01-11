import Foundation

enum HTTPMethod {

    case get([URLQueryItem] = [], percentEnconding: String = "%20")
    case post(Data?)
    case put(Data?)

    var name: String {

        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        }
    }
}

struct Resource<T: Codable> {

    let url: URL
    var method: HTTPMethod = .get()
}

class NetworkManager {

    enum NetworkError: Error {
        case invalidResponse
        case badURL
        case decodingError
        case noComponents
    }

    private let token = Date().tokenString

    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {

        var request = URLRequest(url: resource.url)

        switch resource.method {

        case .post(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data

        case.put(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data

        case .get(let queryItems, let percentEncoding):

            guard
                var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
            else {
                throw NetworkError.noComponents
            }

            let token = [URLQueryItem(name: "token", value: token)]

            if !queryItems.isEmpty {
                components.queryItems = queryItems + token
            } else {
                components.queryItems = token
            }

            components.percentEncodedQuery = components.percentEncodedQuery?
                .replacingOccurrences(of: "%.20", with: percentEncoding)

            guard let url = components.url else {
                throw NetworkError.badURL
            }

            print(url)

            request = URLRequest(url: url)
        }

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]

        let session = URLSession(configuration: configuration)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
            throw NetworkError.decodingError
        }
    }
}
