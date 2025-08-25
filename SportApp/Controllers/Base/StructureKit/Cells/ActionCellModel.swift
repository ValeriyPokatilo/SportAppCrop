import Foundation
import StructureKit

struct ActionCellModel: StructurableForTableView,
                        StructurableIdentifable,
                        StructurableSelectable,
                        StructurableContentIdentifable {

    let id: AnyHashable
    let title: String
    let color: UIColor
    var didSelect: DidSelect?

    func configure(tableViewCell cell: ActionCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(color)
    }
}
