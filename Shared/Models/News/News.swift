import Foundation

struct News: Decodable, Hashable, Identifiable {

    let id: Int
    let title: String
    let body: String
    let date: Date
}

extension News {

    static func getNews() -> Resource<[Self]> {

        guard let url = URL(string: "\(Global.url)/v1/news") else {
            fatalError("URL not found.")
        }

        return Resource(url: url, method: .get(accessToken: Date().tokenString))
    }
}
