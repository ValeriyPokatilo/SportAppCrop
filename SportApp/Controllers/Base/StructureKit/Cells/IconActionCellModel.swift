import Foundation
import StructureKit

struct IconActionCellModel: StructurableForTableView,
                            StructurableIdentifable,
                            StructurableContentIdentifable {

    let id: AnyHashable
    let image: UIImage?
    let color: UIColor
    var tapAction: EmptyBlock?

    func configure(tableViewCell cell: IconActionCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(image)
        hasher.combine(color)
    }
}
