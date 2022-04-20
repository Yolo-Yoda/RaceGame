import Foundation
enum UserDefaultsKeys: String {
    case name
    case speed
    case color
    case obstacles
    case image
    case countGames
    case recordOfGame
    case timeOfLastRecord
    case lastScore
}

struct Obstacles: Codable {
    var smallCar: String
    var bigcar: String
    var motocycle: String
    var tree: String
    var conus: String
    var rock: String
}

struct ResultRace: Codable {
    var name: String
    var score: Int
    var date: Date
    
    func getStringFromDate() -> String {
        let date = DateFormatter()
        date.dateFormat = "d MMM HH:mm"
        let stringDate = date.string(from: .now)
        return stringDate
    }
}
