import Foundation
import StructureKit

struct EmptyCellModel: StructurableForTableView,
                       StructurableHeightable {

    var height: Double = 32.0

    func configure(tableViewCell cell: EmptyCell) {
        cell.configure(with: self)
        cell.backgroundColor = .baseLevelZero25
        cell.contentView.backgroundColor = .baseLevelZero25
        cell.backgroundColor = .baseLevelZero25
    }

    func height(for tableView: StructureKit.NativeTableView) -> CGFloat {
        height
    }
}
