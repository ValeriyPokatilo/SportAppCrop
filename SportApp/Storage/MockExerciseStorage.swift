import Foundation
import RxSwift
import RxRelay

final class MockExerciseStorage {

    static let shared = MockExerciseStorage()

    var exerciseList: [ExerciseModel] = []

    private init() {
        loadFromExt()
    }

    private func loadFromExt() {
        exerciseList = MockListExercises
            .shared
            .array
            .sorted(by: { $0.localizedTitle <  $1.localizedTitle })
    }
}
