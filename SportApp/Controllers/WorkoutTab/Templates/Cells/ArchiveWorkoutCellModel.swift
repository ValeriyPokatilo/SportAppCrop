import Foundation
import StructureKit

struct ArchiveWorkoutCellModel: StructurableForTableView,
                                StructurableIdentifable,
                                StructurableSelectable,
                                StructurableContentIdentifable {

    let workout: WorkoutModel
    let deleteSwipeAction: EmptyBlock?
    let moveWorkoutFromArchive: EmptyBlock?
    let didSelect: DidSelect?

    func configure(tableViewCell cell: ArchiveWorkoutCell) {
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
