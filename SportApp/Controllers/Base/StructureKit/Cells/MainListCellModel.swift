import StructureKit

struct MainListCellModel: StructurableForTableView,
                          StructurableIdentifable,
                          StructurableSelectable,
                          StructurableContentIdentifable {

    let id: String
    let title: String
    let description: String
    let didSelect: DidSelect?

    func configure(tableViewCell cell: MainListCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
    }
}
