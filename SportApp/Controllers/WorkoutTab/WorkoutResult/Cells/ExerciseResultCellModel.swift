import Foundation
import StructureKit

struct ExerciseResultCellModel: StructurableForTableView,
                                StructurableIdentifable,
                                StructurableContentIdentifable {

    let exercise: ExerciseModel
    let sets: [SetEntity]
    let archive: SetArchive

    func configure(tableViewCell cell: ExerciseResultCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(exercise.id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(exercise)
    }
}
