import Foundation
import StructureKit

struct WorkoutCellModel: StructurableForTableView,
                         StructurableIdentifable,
                         StructurableSelectable,
                         StructurableContentIdentifable {

    let workout: WorkoutModel
    let deleteSwipeAction: EmptyBlock?
    let editSwipeAction: EmptyBlock?
    let moveWorkoutToArchive: EmptyBlock?
    let didSelect: DidSelect?

    func configure(tableViewCell cell: WorkoutCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(workout.id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(workout)
        for item in workout.getExercises() {
            hasher.combine(item.title)
            hasher.combine(item.unitType)
        }
    }
}
