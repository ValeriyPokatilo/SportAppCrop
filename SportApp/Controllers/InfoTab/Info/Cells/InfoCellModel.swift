import Foundation
import StructureKit

struct InfoCellModel: StructurableForTableView,
                      StructurableIdentifable,
                      StructurableSelectable,
                      StructurableContentIdentifable {

    let id: AnyHashable
    let item: InfoItems
    let didSelect: DidSelect?

    func configure(tableViewCell cell: InfoCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(item.title)
        hasher.combine(item.description)
    }
}
