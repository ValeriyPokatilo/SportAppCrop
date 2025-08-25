import Foundation

struct ExerciseFilter {
    var equipment: Equipment?
    var muscle: MuscleGroup?
    var unitType: UnitType?

    var isChanged: Bool {
        equipment != nil ||  muscle != nil || unitType != nil
    }
}
