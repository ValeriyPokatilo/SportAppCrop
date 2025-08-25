import Foundation

final class ExerciseStringService {
    static func makeDescString(_ exercise: ExerciseModel) -> String {
        let unit = exercise.unitType
        return "\(unit.title) - \(unit.descriptionReps)"
    }

    static func makeMuscleString(_ exercise: ExerciseModel) -> String {
        return exercise.muscleGroups?.map({
            $0.title
        }).joined(separator: ", ") ?? MuscleGroup.other.title
    }

    static func makeEqString(_ exercise: ExerciseModel) -> String {
        return exercise
            .equipment?
            .map({ $0.title })
            .joined(separator: ", ") ?? Equipment.bodyweight.title
    }
}
