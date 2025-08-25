import Foundation
import StructureKit

final class SetsArviveCellModel: StructurableForTableView,
                                 StructurableIdentifable,
                                 StructurableContentIdentifable {

    let exercise: ExerciseModel
    let archive: SetArchive
    var showSetView: ParameterBlock<SetEntity>?

    init(
        exercise: ExerciseModel,
        archive: SetArchive,
        showSetView: ParameterBlock<SetEntity>?
    ) {
        self.exercise = exercise
        self.archive = archive
        self.showSetView = showSetView
    }

    func configure(tableViewCell cell: SetsArviveCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(exercise.id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(exercise)
    }
}
