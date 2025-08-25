import ActivityKit

struct ActivityAttribute: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var dynamicStringValue: String
        var dynamicIntValue: Int
        var dynamicBoolValue: Bool
    }

    var staticStringValue: String
    var staticIntValue: Int
    var staticBoolValue: Bool
}
