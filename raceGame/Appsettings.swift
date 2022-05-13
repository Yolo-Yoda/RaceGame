import Foundation
import UIKit

class AppSettings {
    
    public static var shared = AppSettings()
    
    private init() { }
    
    // MARK: - Public properties
    
    var obstaclesArray: [Bool]  {[
        AppSettings.shared.obstacles.smallCar,
        AppSettings.shared.obstacles.bigcar,
        AppSettings.shared.obstacles.motocycle,
        AppSettings.shared.obstacles.tree,
        AppSettings.shared.obstacles.conus,
        AppSettings.shared.obstacles.rock
    ]}
    
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
            else { return Obstacles(smallCar: false,
                                    bigcar: false,
                                    motocycle: false,
                                    tree: false,
                                    conus: false,
                                    rock: true)}
            let decoder = JSONDecoder()
            let decodedObstacles = try? decoder.decode(Obstacles.self, from: data)
            return decodedObstacles ?? Obstacles(smallCar: false,
                                                 bigcar: false,
                                                 motocycle: false,
                                                 tree: false,
                                                 conus: false,
                                                 rock: true)
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
    var lastScores: ResultRace {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.lastScores.rawValue)
            else { return ResultRace(name: "", score: 0, date: .now) }
            let decoder = JSONDecoder()
            let decodedResultRace = try? decoder.decode(ResultRace.self, from: data)
            return decodedResultRace ?? ResultRace(name: "", score: 0, date: .now)
        }
        set (newLastScore) {
            let encoder = JSONEncoder()
            let encodedData = try? encoder.encode(newLastScore)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.lastScores.rawValue)
        }
    }
}
