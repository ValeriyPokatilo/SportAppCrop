import Foundation
import StructureKit

struct EquipmentGroupCellModel: StructurableForTableView,
                                StructurableIdentifable,
                                StructurableContentIdentifable {

    let id: AnyHashable
    let group1: Equipment?
    let group1Selected: Bool
    let group2: Equipment?
    let group2Selected: Bool
    let group3: Equipment?
    let group3Selected: Bool
    let group4: Equipment?
    let group4Selected: Bool
    let valueChanged: ParameterBlock<Equipment>

    func configure(tableViewCell cell: EquipmentGroupCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(group1)
        hasher.combine(group1Selected)
        hasher.combine(group2)
        hasher.combine(group2Selected)
        hasher.combine(group3)
        hasher.combine(group3Selected)
        hasher.combine(group4)
        hasher.combine(group4Selected)
    }
}
