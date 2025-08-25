import Foundation
import StructureKit

struct LabelHeaderViewModel: StructureTableSectionHeaderFooter,
                             StructurableHeightable,
                             StructureSectionHeaderFooterContentIdentifable {

    var id: AnyHashable
    var title: String
    var height: Double = 36.0
    var backgroundColor: UIColor = .baseLevelZero50

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func height(for tableView: UITableView) -> CGFloat {
        height
    }

    func configure(tableViewHeaderFooterView view: LabelHeaderView, isUpdating: Bool) {
        view.backgroundColor = backgroundColor
        view.contentView.backgroundColor = backgroundColor
        view.titleLabel.text = title
    }
}
