import SwiftUI

struct HabitModel: Hashable, Codable {
    var name: String
    var motivation: String
    var progress: Double // 0...1
    var color: Color
    
    /// нужно добавлять через метод и чекать по дате
    private(set) var habitProgresses: [HabitProgress] = []
}

struct HabitProgress: Hashable, Codable {
    var done: Bool
    var date: Date
}
