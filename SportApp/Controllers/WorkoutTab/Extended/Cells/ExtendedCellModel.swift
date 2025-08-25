import Foundation
import StructureKit

final class ExtendedCellModel: StructurableForTableView,
                                StructurableIdentifable,
                                StructurableContentIdentifable {

    let exercise: ExerciseModel
    let sets: [SetEntity]
    let archive: SetArchive
    let plusTapAction: EmptyBlock
    let showInfo: EmptyBlock
    var showSetView: ParameterBlock<SetEntity?>?

    init(
        exercise: ExerciseModel,
        sets: [SetEntity],
        archive: SetArchive,
        plusTapAction: @escaping EmptyBlock,
        showInfo: @escaping EmptyBlock,
        showSetView: ParameterBlock<SetEntity?>?
    ) {
        self.exercise = exercise
        self.sets = sets
        self.archive = archive
        self.plusTapAction = plusTapAction
        self.showInfo = showInfo
        self.showSetView = showSetView
    }

    func configure(tableViewCell cell: ExtendedCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(exercise.id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(exercise)
        hasher.combine(archive.date)
        for item in sets {
            hasher.combine(item)
            hasher.combine(item.reps)
            hasher.combine(item.weight)
        }
        for item in archive.sets {
            hasher.combine(item)
            hasher.combine(item.reps)
            hasher.combine(item.weight)
        }
    }
}
