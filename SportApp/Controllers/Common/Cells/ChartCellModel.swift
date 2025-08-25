import Foundation
import StructureKit

struct ChartCellModel: StructurableForTableView,
                       StructurableIdentifable,
                       StructurableContentIdentifable {

    let id: AnyHashable
    let unitString: String
    let values: [Double]

    func configure(tableViewCell cell: ChartCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(unitString)

        for item in values {
            hasher.combine(item)
        }
    }
}
