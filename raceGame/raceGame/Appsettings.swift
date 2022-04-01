import Foundation

class AppSettings {
    
    public static var shared = AppSettings()
    
    private init() { }
    
    // MARK: - Public properties
    
    var name: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKeys.name.rawValue) ?? "User"
        }
        set (newName) {
            UserDefaults.standard.set(newName, forKey: UserDefaultsKeys.name.rawValue)
        }
    }
    
    var speed: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.speed.rawValue)
        }
        set (newSpeed) {
            UserDefaults.standard.set(newSpeed, forKey: UserDefaultsKeys.speed.rawValue)
        }
    }
    
}
