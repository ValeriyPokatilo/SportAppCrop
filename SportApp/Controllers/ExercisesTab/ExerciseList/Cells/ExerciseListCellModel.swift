import Foundation
import StructureKit

struct ExerciseListCellModel: StructurableForTableView,
                              StructurableIdentifable,
                              StructurableSelectable,
                              StructurableContentIdentifable {

    let exercise: ExerciseModel
    let deleteTitle: String
    let deleteSwipeAction: EmptyBlock?
    let editSwipeAction: EmptyBlock?
    let canEdit: Bool
    let canRemove: Bool
    let didSelect: DidSelect?

    init(exercise: ExerciseModel,
         deleteTitle: String,
         deleteSwipeAction: EmptyBlock?,
         editSwipeAction: EmptyBlock?,
         canEdit: Bool,
         canRemove: Bool = false,
         didSelect: DidSelect?
    ) {
        self.exercise = exercise
        self.deleteTitle = deleteTitle
        self.deleteSwipeAction = deleteSwipeAction
        self.editSwipeAction = editSwipeAction
        self.canEdit = canEdit
        self.canRemove = canRemove
        self.didSelect = didSelect
    }

    func configure(tableViewCell cell: ExerciseListCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(exercise.id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(exercise)
    }
}
