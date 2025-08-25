import Foundation
import StructureKit
import RxSwift

struct TimerHeaderModel: StructureTableSectionHeaderFooter,
                         StructurableHeightable,
                         StructureSectionHeaderFooterContentIdentifable {

    let id: AnyHashable
    let conf: TimerConf
    let updateTimer: ParameterBlock<TimerConf>
    var isRunning: Observable<Bool>?

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func height(for tableView: UITableView) -> CGFloat {
        return 54
    }

    func configure(tableViewHeaderFooterView view: TimerHeader, isUpdating: Bool) {
        view.configure(with: self)
    }
}
