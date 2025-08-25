import Foundation
import StructureKit

struct ExerciseSegmentedCellModel: StructurableForTableView,
                                   StructurableIdentifable {

    let id: AnyHashable
    let index: Int
    let valueChanged: ParameterBlock<Int>

    func configure(tableViewCell cell: ExerciseSegmentedCell) {
        cell.configure(with: self)
        cell.valueChanged = valueChanged
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
