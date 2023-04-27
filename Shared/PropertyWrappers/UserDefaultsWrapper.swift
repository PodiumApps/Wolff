import Foundation

enum UserDefaultsKeys: String {
    
    case drivers = "com.tomasmamede.slipstream-drivers"
    case constructors = "com.tomasmamede.slipstream-constructors"
    case user = "com.tomasmamede.slipstream-user"
    case firstTime = "com.tomasmamede.slipstream-first-time"
}

@propertyWrapper
struct UserDefaultsWrapper<T: Codable> {
    
    private let userDefaults: UserDefaults
    private let key: UserDefaultsKeys
    
    var wrappedValue: T? {
        get {
          guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
          let object = try? JSONDecoder().decode(T.self, from: data)
          return object
        }
        
        set {
          guard let object = newValue else { return }
          let data = try? JSONEncoder().encode(object)
          userDefaults.set(data, forKey: key.rawValue)
        }
      }
    
    init(
        userDefaults: UserDefaults = UserDefaults.standard,
        key: UserDefaultsKeys
    ) {
        
        self.userDefaults = userDefaults
        self.key = key
      }
}
