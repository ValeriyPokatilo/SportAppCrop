import Foundation
import StructureKit
import RxSwift
import RxCocoa

final class ExerciseEditViewController: StructurKitController {}

final class ExerciseEditViewModel: StructurKitViewModelAbstract, TableViewDidLoad {
    let title = BehaviorRelay<String?>(value: "")
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [
        InputCell.self,
        LabelCell.self,
        UnitTypeCell.self,
        EmptyGroupCell.self,
        ExerciseGroupCell.self
    ]
    var rightBarButtonItem: UIBarButtonItem?
    let showAlert: BehaviorRelay<AlertConfiguration?> = .init(value: nil)

    var popViewController: EmptyBlock?
    var showMuscleMenu: ParameterBlock<[MuscleGroup]>?
    var showEquipmentMenu: ParameterBlock<[Equipment]>?

    private var muscleButton = MuscleButton<MuscleGroup>(groups: [])
    private var equipmentButton = MuscleButton<Equipment>(groups: [])

    private let showTitleError = BehaviorRelay(value: false)
    private let exercise: ExerciseModel?
    private let exerciseTitle = BehaviorRelay(value: "")
    private let currentUnitType = BehaviorRelay(value: UnitType.withWeight)
    private let currentGroup: BehaviorRelay<[MuscleGroup]> = .init(value: [])
    private let currentEquipment: BehaviorRelay<[Equipment]> = .init(value: [])
    private var isChanged = false
    private let inputIsFirstResponder = BehaviorRelay(value: false)

    private let disposeBag = DisposeBag()

    init(exercise: ExerciseModel?) {
        self.exercise = exercise
        if let exercise {
            fillExercise(exercise)
        }
        configureControl()
        configureDynamics()
    }

    func viewDidLoad() {
        buildCells()
        inputIsFirstResponder.accept(true)
    }

    private func fillExercise(_ exercise: ExerciseModel) {
        title.accept(exercise.title)
        exerciseTitle.accept(exercise.title ?? exercise.localizedTitle)
        currentUnitType.accept(exercise.unitType)
        currentGroup.accept(exercise.muscleGroups ?? [])
        currentEquipment.accept(exercise.equipment ?? [])
    }

    private func configureDynamics() {
        currentGroup
            .subscribe(onNext: { [weak self] items in
                guard let self else {
                    return
                }

                self.muscleButton = MuscleButton(groups: items)
                self.muscleButton.addTarget(self, action: #selector(self.groupTapped), for: .touchUpInside)
                self.buildCells()
            })
            .disposed(by: disposeBag)

        currentEquipment
            .subscribe(onNext: { [weak self] items in
                guard let self else {
                    return
                }

                self.equipmentButton = MuscleButton(groups: items)
                self.equipmentButton.addTarget(self, action: #selector(self.equipmentTapped), for: .touchUpInside)
                self.buildCells()
            })
            .disposed(by: disposeBag)
    }

    private func configureControl() {
        title.accept(exercise?.title ?? "newExerciseStr".localized())

        let saveItem = UIBarButtonItem(
            title: "💾",
            style: .plain,
            target: self,
            action: #selector(saveTapped)
        )

        saveItem.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 24)
        ], for: .normal)

        saveItem.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 24)
        ], for: .highlighted)

        rightBarButtonItem = saveItem
    }

    private func buildCells() {
        var section = StructureSection(identifier: "section")
        var rows = [Structurable]()

        rows += createHeaderRows()
        rows += createMuscleRows()
        rows += createEquipmentRows()

        section.rows = rows
        sections.accept([section])
    }

    private func createHeaderRows() -> [Structurable] {
        var rows: [Structurable] = []

        rows.append(
            InputCellModel(toolbar: addReadyButton())
                .set(value: exerciseTitle.map { Optional($0) })
                .set(valueChanged: { [weak self] newValue in
                    self?.exerciseTitle.accept(newValue ?? "")
                    self?.showTitleError.accept(false)
                    self?.isChanged = true
                })
                .set(firstResponder: inputIsFirstResponder.map { Optional($0) })
                .set(returnKeyType: .done)
                .set(returnKeyTapAction: { [weak self] in
                    if self?.exerciseTitle.value.isEmpty ?? true {
                        self?.showTitleError.accept(true)
                    } else {
                        self?.inputIsFirstResponder.accept(false)
                    }
                })
                .set(showError: showTitleError.map { $0 })
        )

        let unitIndex = UnitType
            .allCases
            .firstIndex(of: exercise?.unitType ?? .withWeight) ?? 0

        rows.append(
            UnitTypeCellModel(
                selectedSegmentIndex: unitIndex,
                valueChanged: { [weak self] unitType in
                    self?.isChanged = true
                    self?.currentUnitType.accept(unitType)
                }
            )
        )

        return rows
    }

    private func createMuscleRows() -> [Structurable] {
        var rows: [Structurable] = []
        rows.append(LabelCellModel(
            id: "muscle",
            text: "musclesStr".localized(),
            size: 12,
            weight: .bold
        ))

        if currentGroup.value.isEmpty {
            rows.append(EmptyGroupCellModel(
                id: "musclePlaceholde",
                didSelect: { [weak self] _ in
                    self?.showMuscleMenu?(self?.currentGroup.value ?? [])
                    return true
                })
            )
        } else {
            rows.append(
                ExerciseGroupCellModel(
                    id: "muscleImgs",
                    muscleImages: muscleButton,
                    equipmentImages: nil
                )
            )
        }

        return rows
    }

    private func createEquipmentRows() -> [Structurable] {
        var rows: [Structurable] = []

        rows.append(LabelCellModel(id: "equipment", text: "equipmentsStr".localized(), size: 12, weight: .bold))

        if currentEquipment.value.isEmpty {
            rows.append(EmptyGroupCellModel(
                id: "equipmentPlaceholde",
                didSelect: { [weak self] _ in
                    self?.showEquipmentMenu?(self?.currentEquipment.value ?? [])
                    return true
                })
            )
        } else {
            rows.append(
                ExerciseGroupCellModel(
                    id: "equipmentImgs",
                    muscleImages: nil,
                    equipmentImages: equipmentButton
                )
            )
        }

        return rows
    }
}

extension ExerciseEditViewModel {
    @objc private func saveTapped() {
        if exerciseTitle.value.isEmpty {
            showTitleError.accept(true)
            return
        }

        let muscles = currentGroup.value.isEmpty ? [MuscleGroup.other] : currentGroup.value
        let equipments = currentEquipment.value.isEmpty ? [Equipment.bodyweight] : currentEquipment.value

        if let exercise {
            // TODO: - exchange name
            let updatedExercise = ExerciseModel(
                id: exercise.id,
                title: exerciseTitle.value,
                unitType: currentUnitType.value,
                muscleGroups: muscles,
                equipment: equipments
            )
            ExerciseStorage.shared.updateExercise(updatedExercise)
        } else {
            let newExercise = ExerciseModel(
                id: UUID(),
                title: exerciseTitle.value,
                unitType: currentUnitType.value,
                muscleGroups: muscles,
                equipment: equipments
            )
            AnalyticsManager.shared.logExerciseCreated(unit: currentUnitType.value)
            ExerciseStorage.shared.addExercise(newExercise)
        }

        popViewController?()
    }

    private func addReadyButton() -> UIToolbar {
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()

        let readyButton = UIBarButtonItem(title: "doneStr".localized(),
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapReady))
        readyButton.tintColor = .systemGreen

        keyboardToolBar.items = [.flexBarButton, readyButton]
        return keyboardToolBar
    }

    @objc private func didTapReady() {
        if exerciseTitle.value.isEmpty {
            showTitleError.accept(true)
        } else {
            inputIsFirstResponder.accept(false)
        }
    }

    @objc private func groupTapped() {
        inputIsFirstResponder.accept(false)
        showMuscleMenu?(currentGroup.value)
    }

    @objc private func equipmentTapped() {
        showEquipmentMenu?(currentEquipment.value)
    }
}

extension ExerciseEditViewModel {
    func changeGroup(_ group: [MuscleGroup]) {
        inputIsFirstResponder.accept(false)
        currentGroup.accept(group)
        isChanged = true
    }

    func changeGroup(_ group: [Equipment]) {
        currentEquipment.accept(group)
        isChanged = true
    }
}

extension ExerciseEditViewModel: StructuredTableNavigation {
    func shouldReturn() -> Bool {
        guard isChanged else {
            return true
        }

        let alertConfig = AlertConfiguration(
            title: "shouldReturnAlertTitleStr".localized(),
            message: nil,
            preferredStyle: .alert,
            actions: [
                UIAlertAction(
                    title: "saveNoStr".localized(),
                    style: .destructive
                ) { [weak self] _ in
                    self?.popViewController?()
                },
                UIAlertAction(
                    title: "saveStr".localized(),
                    style: .default
                ) { [weak self] _ in
                    self?.saveTapped()
                }
            ]
        )

        showAlert.accept(alertConfig)
        return false
    }
}
