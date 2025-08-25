import Foundation
import StructureKit

struct TemplateCellModel: StructurableForTableView,
                          StructurableIdentifable,
                          StructurableSelectable,
                          StructurableContentIdentifable {

    let id: AnyHashable
    let template: Template
    let didSelect: DidSelect?

    func configure(tableViewCell cell: TemplateCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(template)
    }
}
