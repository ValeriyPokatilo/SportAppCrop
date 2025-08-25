import Foundation
import StructureKit

struct IndicatorRecordsCellModel: StructurableForTableView,
                                  StructurableIdentifable,
                                  StructurableContentIdentifable {

    let id: AnyHashable
    let indicator: IndicatorEntity
    var recordEdit: DoubleParametersBlock<RecordEntity?, IndicatorEntity?>?

    func configure(tableViewCell cell: IndicatorRecordsCell) {
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
