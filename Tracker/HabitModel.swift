import SwiftUI

struct HabitModel: Hashable, Codable {
    var name: String
    var motivation: String?
    var progress: UInt
    var color: Color?
}
