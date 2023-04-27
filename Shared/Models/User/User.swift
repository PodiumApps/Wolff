import Foundation

struct User: Codable {
    
    let id: String
    let country: String
    var isPremium: Bool
}

extension User {
    
    static func createOrUpdate(isPremium: Bool) -> Resource<String> {
        
        @UserDefaultsWrapper(key: .user) var persistedUser: User?
        
        guard let url = URL(string: "\(Global.url)/v1/user") else { fatalError("URL not found.") }
        
        var user: User = .init(
            id: UUID().uuidString,
            country: Locale.current.language.region?.identifier ?? "No country",
            isPremium: isPremium
        )
        
        if let persistedUser {
            user = persistedUser
            user.isPremium = isPremium
        } else {
            persistedUser = user
        }
        
        return Resource(url: url, method: .post(body: user, accessToken: Date().tokenString))
    }
}
