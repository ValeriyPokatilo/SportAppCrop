import Foundation
import StructureKit
import RxSwift
import RxCocoa

final class WorkoutEditViewController: StructurKitController {}

final class WorkoutEditViewModel: StructurKitViewModelAbstract,
                                  TableViewDidLoad,
                                  TableViewDidAppear,
                                  Plusable {

    let title = BehaviorRelay<String?>(value: "newWorkoutStr".localized())
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [
        LabelCell.self,
        ExerciseListCell.self,
        InputCell.self,
        IconActionCell.self,
        EmptyCell.self
    ]
    let placeholderView: BehaviorRelay<UIView?> = .init(value: nil)
    var movableCells: [UITableViewCell.Type] = [ExerciseListCell.self]

    let showAlert: BehaviorRelay<AlertConfiguration?> = .init(value: nil)
    var rightBarButtonItem: UIBarButtonItem?
    var plusIsHidden: Driver<Bool> {
        plusIsHiddenState.asDriver().map({ $0 })
    }

    var showExerciseList: EmptyBlock?
    var showEditExercise: ParameterBlock<ExerciseModel>?
    var popViewController: EmptyBlock?

    private var isChanged = false
    private var workoutId: UUID?
    private let workout = BehaviorRelay<WorkoutModel?>(value: nil)
    private let workoutStorage = WorkoutStorage.shared
    private let exerciseStorage = ExerciseStorage.shared
    private let workoutTitle = BehaviorRelay(value: "")
    private let workoutExercises = BehaviorRelay(value: [ExerciseModel]())
    private let inputIsFirstResponder = BehaviorRelay(value: false)
    private let showTitleError = BehaviorRelay(value: false)
    private let plusIsHiddenState = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()

    init(workoutId: UUID?) {
        self.workoutId = workoutId

        configureControl()
    }

    func viewDidLoad() {
        configureDynamics()
    }

    func viewDidAppear() {
        if workout.value == nil && workoutTitle.value.isEmpty {
            self.inputIsFirstResponder.accept(true)
        }
    }

    private func configureControl() {
        let saveItem = UIBarButtonItem(
            title: "💾",
            style: .plain,
            target: self,
            action: #selector(saveTap)
        )

        saveItem.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 24)
        ], for: .normal)

        saveItem.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 24)
        ], for: .highlighted)

        rightBarButtonItem = saveItem
    }

    private func configureDynamics() {
        workoutStorage.workoutObservable
            .compactMap { [weak self] workouts in
                workouts.first { $0.id == self?.workoutId }
            }
            .subscribe(onNext: { [weak self] workout in
                self?.workout.accept(workout)
                self?.fill(workout: workout)
            })
            .disposed(by: disposeBag)

        exerciseStorage.exercisesObservable
            .withLatestFrom(workoutExercises) { ($0, $1) }
            .map { exercises, currentWorkoutExercises in
                let exerciseDict = Dictionary(uniqueKeysWithValues: exercises.map { ($0.id, $0) })

                return currentWorkoutExercises.compactMap { oldExercise in
                    exerciseDict[oldExercise.id] ?? oldExercise
                }
            }
            .subscribe(onNext: { [weak self] updatedExercises in
                self?.workoutExercises.accept(updatedExercises)
            })
            .disposed(by: disposeBag)

        workout
            .compactMap { $0?.getExercises() }
            .subscribe(onNext: { [weak self] exercises in
                self?.workoutExercises.accept(exercises)
            })
            .disposed(by: disposeBag)

        workoutExercises
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)

        workoutExercises
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.isChanged = true
            })
            .disposed(by: disposeBag)
    }

    private func buildCells() {
        var tableSections: [StructureSection] = []
        tableSections.append(createTitleSection())

        let exercises = workoutExercises.value
        if exercises.isEmpty {
            plusIsHiddenState.accept(true)
            placeholderView.accept(
                PlaceholderView(title: "addExerciseStr".localized(), createBlock: { [weak self] in
                    self?.showExerciseList?()
                })
            )
        } else {
            placeholderView.accept(nil)
            plusIsHiddenState.accept(false)
            tableSections.append(createExercisesSection())
        }

        sections.accept(tableSections.compactMap { $0 })
    }

    private func createTitleSection() -> StructureSection {
        var section = StructureSection(identifier: "title")
        var rows = [Structurable]()

        rows.append(
            LabelCellModel(id: "workoutName", text: "workoutNameStr".localized(), size: 12)
        )

        rows.append(
            InputCellModel(toolbar: addReadyButton())
                .set(value: workoutTitle.map { Optional($0) })
                .set(valueChanged: { [weak self] newValue in
                    self?.workoutTitle.accept(newValue ?? "")
                    self?.showTitleError.accept(false)
                    self?.isChanged = true
                })
                .set(firstResponder: inputIsFirstResponder.map { Optional($0) })
                .set(returnKeyType: .done)
                .set(returnKeyTapAction: { [weak self] in
                    if self?.workoutTitle.value.isEmpty ?? true {
                        self?.showTitleError.accept(true)
                    } else {
                        self?.inputIsFirstResponder.accept(false)
                    }
                })
                .set(showError: showTitleError.map { $0 })
        )

        section.rows = rows
        return section
    }

    private func createExercisesSection() -> StructureSection {
        var section = StructureSection(identifier: "exetcises")
        var rows = [Structurable]()

        workoutExercises.value.forEach { exercise in
            rows.append(
                ExerciseListCellModel(
                    exercise: exercise,
                    deleteTitle: "removeStr".localized(),
                    deleteSwipeAction: { [weak self] in
                        self?.removeExercise(exercise)
                    },
                    editSwipeAction: { [weak self] in
                        self?.showEditExercise?(exercise)
                    },
                    canEdit: exercise.canEdit ?? true,
                    canRemove: true,
                    didSelect: { _ in return true}
                )
            )
        }

        rows.append(
            EmptyCellModel(height: 80)
        )

        section.rows = rows
        return section
    }

    func plusTapped() {
        showExerciseList?()
    }
}

extension WorkoutEditViewModel {
    private func fill(workout: WorkoutModel) {
        workoutTitle.accept(workout.title)
        title.accept(workout.title)
        workoutExercises.accept(workout.getExercises())
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
}

extension WorkoutEditViewModel {
    func appendExercise(_ exercise: ExerciseModel) {
        var currentExercises = workoutExercises.value
        currentExercises.append(exercise)
        workoutExercises.accept(currentExercises)
    }

    func removeExercise(_ exercise: ExerciseModel) {
        // TODO: - remove by index
        var currentExercises = workoutExercises.value
        currentExercises.removeAll(where: { $0.id == exercise.id })
        workoutExercises.accept(currentExercises)
    }

    @objc private func saveTap() {
        if var workout = workout.value {
            workout.title = workoutTitle.value
            workout.exerciseIds = workoutExercises.value.map({ $0.id })
            workoutStorage.updateWorkout(workout)
            popViewController?()
        } else {
            if workoutTitle.value.isEmpty {
                showTitleError.accept(true)
            } else if workoutExercises.value.isEmpty {
                let alertConfig = AlertConfiguration(
                    title: "emptyExercisesStr".localized(),
                    message: nil,
                    preferredStyle: .alert,
                    actions: [
                        UIAlertAction(
                            title: "okStr".localized(),
                            style: .default
                        )
                    ]
                )
                showAlert.accept(alertConfig)
            } else {
                let newWorkout = WorkoutModel(
                    id: UUID(),
                    title: workoutTitle.value,
                    exerciseIds: workoutExercises.value.map({ $0.id })
                )

                AnalyticsManager.shared.logWorkoutCreated()
                workoutStorage.addWorkout(newWorkout)
                popViewController?()
            }
        }
    }
}

extension WorkoutEditViewModel {
    @objc private func didTapReady() {
        if workoutTitle.value.isEmpty {
            showTitleError.accept(true)
        } else {
            inputIsFirstResponder.accept(false)
        }
    }

    func moveRows(from: Int, to: Int) {
        isChanged = true

        var exercises = workoutExercises.value

        guard from >= 0, from < exercises.count, to >= 0, to < exercises.count else {
            return
        }

        let movedExercise = exercises.remove(at: from)
        exercises.insert(movedExercise, at: to)

        workoutExercises.accept(exercises)

        let new = WorkoutModel(
            id: workout.value?.id ?? UUID(),
            title: workout.value?.title ?? "",
            exerciseIds: workoutExercises.value.map({ $0.id })
        )

        workoutStorage.updateWorkout(new)
    }
}

extension WorkoutEditViewModel: StructuredTableNavigation {
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
                    self?.saveTap()
                }
            ]
        )
        showAlert.accept(alertConfig)
        return false
    }
}
