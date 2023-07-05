import Foundation
import OSLog

struct User: Codable {
    
    typealias ID = Identifier<User>
    let id: User.ID
}

extension User {
    
    struct Post: Encodable {
        
        let id: User.ID
        let country: String
        let isPremium: Bool
        let deviceToken: String?
    }
}

extension User {
    
    static func createOrUpdate(isPremium: Bool = false) -> Resource<Self> {
        
        guard let url = URL(string: "\(Global.url)/v1/user") else { fatalError("URL not found.") }
        
        guard let persistedUserId  = UserDefaults.standard.string(forKey: UserDefaultsKeys.user.rawValue) else {
            return .init(url: url, method: .get(accessToken: nil))
        }
        
        Logger.userService.log("Posting user \(persistedUserId)")
        
        let user: User.Post = .init(
            id: .init(persistedUserId),
            country: Locale.current.language.region?.identifier ?? "No country",
            isPremium: isPremium,
            deviceToken: nil
        )
        
        return Resource(url: url, method: .post(body: user, accessToken: Date().tokenString))
    }
    
    static func update(deviceToken: String) -> Resource<Self> {

        print("APNS token: \(deviceToken)")
        
        guard let url = URL(string: "\(Global.url)/v1/user") else { fatalError("URL not found.") }
        
        guard let persistedUserId  = UserDefaults.standard.string(forKey: UserDefaultsKeys.user.rawValue) else {
            return .init(url: url, method: .get(accessToken: nil))
        }
        
        Logger.userService.log("Updating Device token \(deviceToken) for user \(persistedUserId)")
        
        let user: User.Post = .init(
            id: .init(persistedUserId),
            country: Locale.current.language.region?.identifier ?? "No country",
            isPremium: false, // ⚒️ To not have to create a new model we will send this despite not being used by the BE
            deviceToken: deviceToken
        )
        
        return Resource(url: url, method: .post(body: user, accessToken: Date().tokenString))
    }
}
