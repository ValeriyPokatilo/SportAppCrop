import StructureKit
import RxCocoa
import RxSwift

final class UnitTypeViewController: StructurKitController {}

final class UnitTypeViewModel: StructurKitViewModelAbstract {

    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [UnitTypeCell.self, EmptyCell.self]

    var selectBlock: ParameterBlock<UnitType>?

    init() {
        buildCells()
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        rows.append(EmptyCellModel(height: 20))
        rows.append(UnitTypeCellModel(
            selectedSegmentIndex: nil,
            valueChanged: { [weak self] type in
                self?.selectBlock?(type)
            }
        ))

        section.rows = rows
        sections.accept([section])
    }
}
