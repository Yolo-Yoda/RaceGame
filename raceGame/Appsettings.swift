import Foundation
import UIKit

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
    
    var countGames: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.countGames.rawValue)
        }
        set (newCount) {
            UserDefaults.standard.set(newCount, forKey: UserDefaultsKeys.countGames.rawValue)
        }
    }
    var recordOfGame: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.recordOfGame.rawValue)
        }
        set (newRecord) {
            UserDefaults.standard.set(newRecord, forKey: UserDefaultsKeys.recordOfGame.rawValue)
        }
    }
    
    var carColor: String {
        get {
            guard let value = UserDefaults.standard.string(forKey: UserDefaultsKeys.color.rawValue)
            else {return ""}
            return value
        }
        set (newCarColor) {
            UserDefaults.standard.set(newCarColor, forKey: UserDefaultsKeys.color.rawValue)
            
        }
    }
    var obstacles : Obstacles {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.obstacles.rawValue)
            else { return Obstacles(smallCar: "",
                                    bigcar: "",
                                    motocycle: "",
                                    tree: "",
                                    conus: "",
                                    rock: "")}
            let decoder = JSONDecoder()
            let decodedObstacles = try? decoder.decode(Obstacles.self, from: data)
            return decodedObstacles ?? Obstacles(smallCar: "",
                                                 bigcar: "",
                                                 motocycle: "",
                                                 tree: "",
                                                 conus: "",
                                                 rock: "")
        }
        set (newObstacles){
            let encoder = JSONEncoder()
            let encodedData = try? encoder.encode(newObstacles)
            
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.obstacles.rawValue)
        }
    }
    var image: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKeys.image.rawValue) ?? "ProfileImage"
        }
        set (newName) {
            UserDefaults.standard.set(newName, forKey: UserDefaultsKeys.image.rawValue)
        }
    }
    var timeOfLastRecord: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKeys.timeOfLastRecord.rawValue) ?? ""
        }
        set (newTime) {
            UserDefaults.standard.set(newTime, forKey: UserDefaultsKeys.timeOfLastRecord.rawValue)
        }
    }
    var lastScore: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.lastScore.rawValue)
        }
        set (newLastScore) {
            UserDefaults.standard.set(newLastScore, forKey: UserDefaultsKeys.lastScore.rawValue)
        }
    }
}
