import Foundation

struct SetModel: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var exerciseId = UUID()
    var timeStamp: Date
    var weight: Double
    var reps: Int
}
