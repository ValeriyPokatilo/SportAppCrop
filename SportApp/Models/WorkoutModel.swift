import Foundation

struct WorkoutModel: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var exerciseIds: [UUID]
    var isActive: Bool? = true

    func getExercises() -> [ExerciseModel] {
        let allExercises = ExerciseStorage.shared.exercises + MockExerciseStorage.shared.exerciseList
        var orderedExercises: [ExerciseModel] = []

        for id in exerciseIds {
            if let exercise = allExercises.first(where: { $0.id == id }) {
                orderedExercises.append(exercise)
            }
        }

        return orderedExercises
    }
}
