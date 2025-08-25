import Foundation
import StructureKit

struct TitleCellModel: StructurableForTableView {

    let text: String

    func configure(tableViewCell cell: TitleCell) {
        cell.configure(with: self)
    }
}
