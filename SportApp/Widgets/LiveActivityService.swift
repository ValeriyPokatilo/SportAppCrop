import Foundation
import ActivityKit

enum LiveActivityService {
    static var isEnabled: Bool {
        return ActivityAuthorizationInfo().areActivitiesEnabled
    }

    static var activities: [Activity<ActivityAttribute>] {
        return Activity<ActivityAttribute>.activities
    }

    static func makeActivity(value: String) {
        guard isEnabled else { return }

        let attributes = ActivityAttribute(staticStringValue: "Static", staticIntValue: 1, staticBoolValue: true)

        let contentState = ActivityAttribute.ContentState(
            dynamicStringValue: value,
            dynamicIntValue: 2,
            dynamicBoolValue: true
        )

        do {
            let content = ActivityContent(state: contentState, staleDate: nil)
            _ = try Activity<ActivityAttribute>.request(
                attributes: attributes,
                content: content
            )
        } catch {
            print("LiveActivityService: Error when making new Live Activity: \(error.localizedDescription).")
        }
    }

    static func updateActivity(_ activity: Activity<ActivityAttribute>, value: String) {
        let contentState = ActivityAttribute.ContentState(
            dynamicStringValue: value,
            dynamicIntValue: 2,
            dynamicBoolValue: true
        )
        Task {
            await activity.update(ActivityContent(state: contentState, staleDate: nil))
        }
    }

    static func endActivity(_ activity: Activity<ActivityAttribute>) {
        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
