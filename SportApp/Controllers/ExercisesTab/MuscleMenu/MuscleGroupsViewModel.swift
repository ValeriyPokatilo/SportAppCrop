import StructureKit
import RxCocoa
import RxSwift

final class MuscleGroupsViewController: StructurKitController {}

final class MuscleGroupsViewModel: StructurKitViewModelAbstract {

    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [
        MuscleGroupCell.self,
        EmptyCell.self,
        ActionCell.self
    ]
    let selected: BehaviorRelay<[MuscleGroup]> = .init(value: [])

    var selectBlock: ParameterBlock<[MuscleGroup]>?
    private let isMultipleSelection: Bool
    private var disposeBag = DisposeBag()

    init(selectedGroups: [MuscleGroup], isMultipleSelection: Bool) {
        self.isMultipleSelection = isMultipleSelection

        configureDynamics()
        selected.accept(selectedGroups)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        rows.append(EmptyCellModel(height: 20))

        rows.append(create1row())
        rows.append(create2row())
        rows.append(create3row())

        if isMultipleSelection {
            rows.append(ActionCellModel(
                id: "save",
                title: "saveStr".localized(),
                color: .systemGreen,
                didSelect: { [weak self] _ in
                    self?.saveTapped()
                    return true
                }
            ))
        }

        section.rows = rows
        sections.accept([section])
    }

    private func create1row() -> Structurable {
        return MuscleGroupCellModel(
            id: "line1",
            group1: .chest,
            group1Selected: isMultipleSelection ? selected.value.contains(.chest) : true,
            group2: .back,
            group2Selected: isMultipleSelection ? selected.value.contains(.back) : true,
            group3: .legs,
            group3Selected: isMultipleSelection ? selected.value.contains(.legs) : true,
            valueChanged: { [weak self] group in
                if self?.isMultipleSelection ?? true {
                    self?.updateGroups(group)
                } else {
                    self?.updateGroups(group)
                    self?.saveTapped()
                }
            }
        )
    }

    private func create2row() -> Structurable {
        return MuscleGroupCellModel(
            id: "line2",
            group1: .arms,
            group1Selected: isMultipleSelection ? selected.value.contains(.arms) : true,
            group2: .shoulders,
            group2Selected: isMultipleSelection ? selected.value.contains(.shoulders) : true,
            group3: .coreAbs,
            group3Selected: isMultipleSelection ? selected.value.contains(.coreAbs) : true,
            valueChanged: { [weak self] group in
                if self?.isMultipleSelection ?? true {
                    self?.updateGroups(group)
                } else {
                    self?.updateGroups(group)
                    self?.saveTapped()
                }
            }
        )
    }

    private func create3row() -> Structurable {
        return MuscleGroupCellModel(
            id: "line3",
            group1: .neck,
            group1Selected: isMultipleSelection ? selected.value.contains(.neck) : true,
            group2: .cardio,
            group2Selected: isMultipleSelection ? selected.value.contains(.cardio) : true,
            group3: .other,
            group3Selected: isMultipleSelection ? selected.value.contains(.other) : true,
            valueChanged: { [weak self] group in
                if self?.isMultipleSelection ?? true {
                    self?.updateGroups(group)
                } else {
                    self?.updateGroups(group)
                    self?.saveTapped()
                }
            }
        )
    }

    private func saveTapped() {
        self.selectBlock?(selected.value)
    }

    private func updateGroups(_ group: MuscleGroup) {
        if selected.value.contains(group) {
            var state = selected.value
            state.removeAll(where: { $0 == group })
            selected.accept(state)
        } else {
            var state = selected.value
            state.append(group)
            selected.accept(state)
        }
    }

    private func configureDynamics() {
        selected
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)
    }
}
