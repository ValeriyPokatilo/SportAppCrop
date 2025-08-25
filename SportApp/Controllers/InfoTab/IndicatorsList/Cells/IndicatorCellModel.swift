import Foundation
import StructureKit

struct IndicatorCellModel: StructurableForTableView,
                           StructurableIdentifable,
                           StructurableContentIdentifable {

    let id: AnyHashable
    let indicator: IndicatorEntity
    let plusTapAction: EmptyBlock
    let editTapAction: EmptyBlock
    var recordEdit: DoubleParametersBlock<RecordEntity?, IndicatorEntity?>?
    let moreAction: EmptyBlock

    func configure(tableViewCell cell: IndicatorCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(indicator.title)
        hasher.combine(indicator.unit)
        if let records = indicator.records as? Set<RecordEntity> {
            for record in records {
                hasher.combine(record.value)
                hasher.combine(record.timestamp)
            }
        }
    }
}
