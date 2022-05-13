import Foundation

struct ResultRace: Codable {
    var name: String
    var score: Int
    var date: Date
    
    func getStringFromDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "d MMM HH:mm"
        return dateFormater.string(from: date)
    }
}
