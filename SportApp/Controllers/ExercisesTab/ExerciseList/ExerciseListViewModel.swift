import Foundation
import StructureKit
import RxSwift
import RxCocoa

final class ExerciseListViewController: StructurKitController {}

final class ExerciseListViewModel: StructurKitViewModelAbstract,
                                   TableViewDidLoad,
                                   Searchable,
                                   Plusable {

    let title = BehaviorRelay<String?>(value: "exercisesTitleStr".localized())
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [ExerciseListCell.self]
    let searchText = BehaviorRelay<String?>(value: nil)
    let placeholderView: BehaviorRelay<UIView?> = .init(value: nil)
    var showAlert: BehaviorRelay<AlertConfiguration?> = .init(value: nil)
    var plusIsHidden: Driver<Bool> {
        .just(false)
    }
    var filter: Driver<ExerciseFilter> {
        filterState.asDriver().map({ $0 })
    }

    var rightBarButtonItem: UIBarButtonItem?

    var selectBlock: ParameterBlock<ExerciseModel>?
    var createBlock: EmptyBlock?
    var editBlock: ParameterBlock<ExerciseModel>?
    var showPurchaseView: EmptyBlock?

    var equipmentTap: EmptyBlock?
    var muscleTap: EmptyBlock?
    var unitTypeTap: EmptyBlock?

    private let filterState = BehaviorRelay(value: ExerciseFilter())
    private let exercises = BehaviorRelay(value: [ExerciseModel]())
    private let actionHidden = BehaviorRelay(value: true)
    private let workoutStorage = WorkoutStorage.shared
    private let exerciseStorage = ExerciseStorage.shared
    private let coreDataManager = CoreDataManager.shared
    private let mockExerciseStorage = MockExerciseStorage.shared
    private let disposeBag = DisposeBag()

    init() {
        configureControl()
    }

    func viewDidLoad() {
        configureDynamics()
    }

    private func configureControl() {
        rightBarButtonItem = UIBarButtonItem(
            image: .plusImg,
            style: .plain,
            target: self,
            action: #selector(plusTap)
        )
    }

    private func configureDynamics() {
        exerciseStorage.exercisesObservable
            .subscribe(onNext: { [weak self] items in
                self?.exercises.accept(items + (self?.mockExerciseStorage.exerciseList ?? []))
            })
            .disposed(by: disposeBag)

        exercises
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)

        filterState
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)

        searchText
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        if exercises.value.isEmpty {
            actionHidden.accept(true)
            placeholderView.accept(
                PlaceholderView(
                    title: "createExerciseStr".localized(),
                    createBlock: { [weak self] in
                        self?.createBlock?()
                    }
                )
            )
        } else {
            placeholderView.accept(nil)
            actionHidden.accept(false)

            rows += createExerciseRow()
        }

        section.rows = rows
        sections.accept([section])
    }

    @objc private func plusTap() {
//        if PurchaseManager.shared.rights == .all {
            createBlock?()
//        } else {
//            showPurchaseView?()
//        }
    }

    private func createExerciseRow() -> [Structurable] {
        var rows = [Structurable]()

        var exerciseList = exercises.value

        if let text = searchText.value, !text.isEmpty {
            exerciseList = exerciseList.filter({
                $0.localizedTitle.normalizedForSearch.contains(text.normalizedForSearch) ||
                ($0.title ?? "").normalizedForSearch.contains(text.normalizedForSearch)
            })
        }

        if let equipment = filterState.value.equipment {
            exerciseList = exerciseList.filter({
                ($0.equipment ?? []).contains(equipment)
            })
        }

        if let unitType = filterState.value.unitType {
            exerciseList = exerciseList.filter({ $0.unitType == unitType })
        }

        if let muscle = filterState.value.muscle {
            exerciseList = exerciseList.filter({ ($0.muscleGroups ?? []).contains(muscle) })
        }

        exerciseList.forEach { ex in
            rows.append(
                ExerciseListCellModel(
                    exercise: ex,
                    deleteTitle: "deleteStr".localized(),
                    deleteSwipeAction: { [weak self] in
                        self?.showAlert.accept(self?.createAlert(exercise: ex))
                    },
                    editSwipeAction: { [weak self] in
                        self?.editBlock?(ex)
                    },
                    canEdit: ex.canEdit ?? true,
                    didSelect: { [weak self] _ in
                        self?.selectBlock?(ex)
                        return true
                    }
                )
            )
        }

        return rows
    }

    private func createAlert(exercise: ExerciseModel) -> AlertConfiguration {
        return AlertConfiguration(
            title: "exerciseAlertAlertTitleStr".localized(),
            message: "exerciseAlertAlertMessageStr".localized(),
            preferredStyle: .alert,
            actions: [
                UIAlertAction(title: "deleteStr".localized(), style: .destructive) { [weak self] _ in
                    self?.coreDataManager.removeAllSets(for: exercise.id)
                    self?.workoutStorage.removeExercise(fromWorkouts: exercise.id)
                    self?.exerciseStorage.removeExercise(by: exercise.id)
                },
                UIAlertAction(title: "cancelStr".localized(), style: .default)
            ]
        )
    }

    func plusTapped() {
        plusTap()
    }

    func equipmentTapped() {
        equipmentTap?()
    }

    func muscleTapped() {
        muscleTap?()
    }

    func unitTypeTapped() {
        unitTypeTap?()
    }

    func clearTapped() {
        filterState.accept(ExerciseFilter())
    }
}

extension ExerciseListViewModel {
    func setEquipment(_ equipment: Equipment?) {
        var state = filterState.value
        state.equipment = equipment
        filterState.accept(state)
    }

    func setMuscle(_ muscle: MuscleGroup?) {
        var state = filterState.value
        state.muscle = muscle
        filterState.accept(state)
    }

    func setUnitType(_ unitType: UnitType?) {
        var state = filterState.value
        state.unitType = unitType
        filterState.accept(state)
    }
}

extension ExerciseListViewModel: StructuredTableNavigation {
    func shouldReturn() -> Bool {
        return true
    }
}
