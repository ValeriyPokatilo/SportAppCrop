import Foundation
import StructureKit

struct TemplateSegmentedCellModel: StructurableForTableView,
                                        StructurableIdentifable {

    let id: AnyHashable
    let index: Int
    let valueChanged: ParameterBlock<Int>

    func configure(tableViewCell cell: TemplateSegmentedCell) {
        cell.configure(with: self)
        cell.valueChanged = valueChanged
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
