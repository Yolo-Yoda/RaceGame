enum UserDefaultsKeys: String {
    case name
    case speed
    case color
    case obstacles
    case image
    case countGames
    case recordOfGame
}

struct Obstacles: Codable {
    var smallCar: String
    var bigcar: String
    var motocycle: String
    var tree: String
    var conus: String
    var rock: String
}
