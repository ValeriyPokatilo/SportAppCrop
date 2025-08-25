import UIKit
import StructureKit

final class ExerciseGroupCellModel: StructurableForTableView,
                                    StructurableIdentifable,
                                    StructurableContentIdentifable {

    let id: AnyHashable
    let muscleImages: MuscleButton<MuscleGroup>?
    let equipmentImages: MuscleButton<Equipment>?

    init(
        id: AnyHashable,
        muscleImages: MuscleButton<MuscleGroup>?,
        equipmentImages: MuscleButton<Equipment>?
    ) {
        self.id = id
        self.muscleImages = muscleImages
        self.equipmentImages = equipmentImages
    }

    func configure(tableViewCell cell: ExerciseGroupCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(muscleImages)
        hasher.combine(equipmentImages)
    }
}
