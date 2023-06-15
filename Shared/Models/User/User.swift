import Foundation

struct User: Codable {
    
    typealias ID = Identifier<User>
    let id: User.ID
}

extension User {
    
    struct Post: Encodable {
        
        let id: User.ID
        let country: String
        let isPremium: Bool
    }
}

extension User {
    
    static func createOrUpdate(isPremium: Bool = false) -> Resource<User> {
        
        @UserDefaultsWrapper(key: .user) var persistedUserId: String?
        
        guard let url = URL(string: "\(Global.url)/v1/user") else { fatalError("URL not found.") }
        
        let user: User.Post = .init(
            id: .init(persistedUserId ?? UUID().uuidString),
            country: Locale.current.language.region?.identifier ?? "No country",
            isPremium: isPremium
        )
        
        return Resource(url: url, method: .post(body: user, accessToken: Date().tokenString))
    }
}
