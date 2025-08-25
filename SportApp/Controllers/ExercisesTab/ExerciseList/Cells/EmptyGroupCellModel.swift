import Foundation
import StructureKit

final class EmptyGroupCellModel: StructurableForTableView,
                                 StructurableIdentifable,
                                 StructurableSelectable {

    let id: AnyHashable
    let didSelect: DidSelect?

    init(
        id: AnyHashable,
        didSelect: DidSelect? = nil
    ) {
        self.id = id
        self.didSelect = didSelect
    }

    func configure(tableViewCell cell: EmptyGroupCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
