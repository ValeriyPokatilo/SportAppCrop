import Foundation
import StructureKit

struct MuscleGroupCellModel: StructurableForTableView,
                             StructurableIdentifable,
                             StructurableContentIdentifable {

    let id: AnyHashable
    let group1: MuscleGroup
    let group1Selected: Bool
    let group2: MuscleGroup
    let group2Selected: Bool
    let group3: MuscleGroup
    let group3Selected: Bool
    let valueChanged: ParameterBlock<MuscleGroup>

    func configure(tableViewCell cell: MuscleGroupCell) {
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
    }
}
