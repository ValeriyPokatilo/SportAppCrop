import StructureKit
import RxCocoa
import RxSwift

final class EquipmentViewController: StructurKitController {}

final class EquipmentViewModel: StructurKitViewModelAbstract {

    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [
        EquipmentGroupCell.self,
        EmptyCell.self,
        ActionCell.self
    ]
    let selected: BehaviorRelay<[Equipment]> = .init(value: [])

    var selectBlock: ParameterBlock<[Equipment]>?
    private let isMultipleSelection: Bool
    private var disposeBag = DisposeBag()

    init(selectedGroups: [Equipment], isMultipleSelection: Bool) {
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
        rows.append(create4row())

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
        return EquipmentGroupCellModel(
            id: "line1",
            group1: .plate,
            group1Selected: isMultipleSelection ? selected.value.contains(.plate) : true,
            group2: .machine,
            group2Selected: isMultipleSelection ? selected.value.contains(.machine) : true,
            group3: .cardioMachine,
            group3Selected: isMultipleSelection ? selected.value.contains(.cardioMachine) : true,
            group4: .kettlebell,
            group4Selected: isMultipleSelection ? selected.value.contains(.kettlebell) : true,
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
        return EquipmentGroupCellModel(
            id: "line2",
            group1: .dumbbell,
            group1Selected: isMultipleSelection ? selected.value.contains(.dumbbell) : true,
            group2: .barbell,
            group2Selected: isMultipleSelection ? selected.value.contains(.barbell) : true,
            group3: .resistanceBand,
            group3Selected: isMultipleSelection ? selected.value.contains(.resistanceBand) : true,
            group4: .ball,
            group4Selected: isMultipleSelection ? selected.value.contains(.ball) : true,
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
        return EquipmentGroupCellModel(
            id: "line3",
            group1: .bench,
            group1Selected: isMultipleSelection ? selected.value.contains(.bench) : true,
            group2: .parallelBars,
            group2Selected: isMultipleSelection ? selected.value.contains(.parallelBars) : true,
            group3: .pullUpBar,
            group3Selected: isMultipleSelection ? selected.value.contains(.pullUpBar) : true,
            group4: .rope,
            group4Selected: isMultipleSelection ? selected.value.contains(.rope) : true,
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

    private func create4row() -> Structurable {
        return EquipmentGroupCellModel(
            id: "line4",
            group1: .bodyweight,
            group1Selected: isMultipleSelection ? selected.value.contains(.bodyweight) : true,
            group2: .other,
            group2Selected: isMultipleSelection ? selected.value.contains(.other) : true,
            group3: nil,
            group3Selected: false,
            group4: nil,
            group4Selected: false,
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
        selectBlock?(selected.value)
    }

    private func updateGroups(_ group: Equipment) {
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
