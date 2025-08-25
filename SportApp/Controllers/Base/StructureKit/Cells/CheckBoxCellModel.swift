import RxSwift
import StructureKit

struct CheckBoxCellModel: StructurableForTableView,
                          StructurableIdentifable,
                          StructurableContentIdentifable {

    var id: AnyHashable?
    var title: String?
    let selected: Observable<Bool>
    var checkboxAction: ParameterBlock<Bool>?

    func configure(tableViewCell cell: CheckBoxCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
