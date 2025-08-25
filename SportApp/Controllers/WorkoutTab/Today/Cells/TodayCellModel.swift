import Foundation
import StructureKit

final class TodayCellModel: StructurableForTableView,
                            StructurableIdentifable,
                            StructurableContentIdentifable {

    let exercise: ExerciseModel
    let sets: [SetEntity]
    let archive: SetArchive
    let plusTapAction: EmptyBlock
    let showPrevious: EmptyBlock
    let showInfo: EmptyBlock
    var showSetView: ParameterBlock<SetEntity>?

    init(
        exercise: ExerciseModel,
        sets: [SetEntity],
        archive: SetArchive,
        plusTapAction: @escaping EmptyBlock,
        showPrevious: @escaping EmptyBlock,
        showInfo: @escaping EmptyBlock,
        showSetView: ParameterBlock<SetEntity>?
    ) {
        self.exercise = exercise
        self.sets = sets
        self.archive = archive
        self.plusTapAction = plusTapAction
        self.showPrevious = showPrevious
        self.showInfo = showInfo
        self.showSetView = showSetView
    }

    func configure(tableViewCell cell: TodayCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(exercise.id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(exercise)
        for item in sets {
            hasher.combine(item.reps)
            hasher.combine(item.weight)
            hasher.combine(item.timeStamp)
        }
    }
}
