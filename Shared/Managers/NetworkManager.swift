import Foundation

final class NetworkManager: NetworkManagerRepresentable {

    static let shared = NetworkManager()

    func load<T: Decodable>(_ resource: Resource<T>) async throws -> T {

        var request = URLRequest(url: resource.url)

        switch resource.method {

        case .post(let body, let token):
            request.httpMethod = resource.method.name
            
            do {
                let data = try JSONEncoder().encode(body)
                request.httpBody = data
            } catch {
                throw NetworkError.encodingError(error)
            }
            
            if let token { request.addValue(token, forHTTPHeaderField: "x-secret-key") }

        case .get(let queryItems, let token):
            
            guard
                var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
            else {
                throw NetworkError.noComponents
            }
            
            components.queryItems = queryItems

            guard let url = components.url else { throw NetworkError.badUrl(components.url) }

            request = URLRequest(url: url)
            
            if let token { request.addValue(token, forHTTPHeaderField: "x-secret-key") }
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        let session = URLSession(configuration: configuration)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.badResponse(response) }
        
        if httpResponse.statusCode == 200 {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(.standard)
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } else {
            do {
                throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode, "Invalid response")
            } catch {
                throw NetworkError.decodingError(error)
            }
        }
    }
}
