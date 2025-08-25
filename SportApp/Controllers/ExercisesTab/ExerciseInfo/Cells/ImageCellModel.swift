import Foundation
import StructureKit

final class ImageCellModel: StructurableForTableView,
                            StructurableIdentifable,
                            StructurableContentIdentifable {

    let id: AnyHashable
    let imageName: String?

    init(id: AnyHashable, imageName: String?) {
        self.id = id
        self.imageName = imageName
    }

    func configure(tableViewCell cell: ImageCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(imageName)
    }
}
