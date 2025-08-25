import Foundation
import StructureKit
import RxSwift
import RxCocoa

final class TodayViewController: StructurKitController {}

final class TodayViewModel: StructurKitViewModelAbstract, TableViewDidLoad {

    var title = BehaviorRelay<String?>(value: "")
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [
        TodayCell.self,
        YesterdayCell.self,
        ActionCell.self
    ]
    var headerFooterTypes: [UIView.Type] = [TimerHeader.self]

    var showSetView: DoubleParametersBlock<ExerciseModel, SetEntity?>?
    var showExerciseInfo: ParameterBlock<ExerciseModel>?
    var showResults: ParameterBlock<UUID>?
    var editWorkout: ParameterBlock<UUID>?
    var rightBarButtonItem: UIBarButtonItem?

    private let workoutId: UUID
    private var sets: [SetEntity] = []
    private let workout = BehaviorRelay<WorkoutModel?>(value: nil)
    private let exercisesList = BehaviorRelay(value: [ExerciseModel]())
    private let selectedExerciseId = BehaviorRelay<UUID?>(value: nil)
    private let timerIsActive = BehaviorRelay<Bool>(value: false)

    private let coreDataManager = CoreDataManager.shared
    private let workoutStorage = WorkoutStorage.shared
    private let confStorage = ConfStorage.shared
    private let disposeBag = DisposeBag()

    init(workoutId: UUID) {
        self.workoutId = workoutId
        configureControl()
    }

    func viewDidLoad() {
        configureDynamics()
    }

    private func configureControl() {
        rightBarButtonItem = UIBarButtonItem(
            image: .editImg,
            style: .plain,
            target: self,
            action: #selector(editTap)
        )
    }

    private func configureDynamics() {
        workoutStorage.workoutObservable
            .compactMap { [weak self] workouts in
                workouts.first { $0.id == self?.workoutId }
            }
            .subscribe(onNext: { [weak self] workout in
                self?.workout.accept(workout)
                self?.title.accept(workout.title)
            })
            .disposed(by: disposeBag)

        workout
            .compactMap { $0?.getExercises() }
            .subscribe(onNext: { [weak self] exercises in
                self?.exercisesList.accept(exercises)
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(exercisesList, selectedExerciseId)
            .subscribe(onNext: { [weak self] _, _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)

        coreDataManager.setsObservable
            .subscribe(onNext: { [weak self] sets in
                guard let self else {
                    return
                }

                if self.sets.count < sets.count {
                    timerIsActive.accept(true)
                }

                self.sets = sets
                self.buildCells()
            })
            .disposed(by: disposeBag)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        section.header = .view(TimerHeaderModel(
            id: "timer",
            conf: confStorage.conf.timerConf ?? TimerConf(isEnabled: true, value: 90),
            updateTimer: { [weak self] timer in
                self?.updateTimerConf(timer)
            },
            isRunning: timerIsActive.map({ $0 })
        ))

        exercisesList.value.forEach { exercise in
            if exercise.id == selectedExerciseId.value {
                rows.append(
                    buildYesterdayRow(exercise: exercise)
                )
            } else {
                rows.append(
                    buildTodayRow(exercise: exercise)
                )
            }
        }

        rows.append(
            ActionCellModel(
                id: "result",
                title: "🏁 \("resultsStr".localized()) 🏁",
                color: .systemGreen,
                didSelect: { [weak self] _ in
                    guard let self else {
                        return false
                    }
                    self.showResults?(self.workoutId)
                    return true
                }
            )
        )

        section.rows = rows
        sections.accept([section])
    }

    private func buildTodayRow(exercise: ExerciseModel) -> Structurable {
        return TodayCellModel(
            exercise: exercise,
            sets: sets.filter({ $0.exerciseId == exercise.id}),
            archive: coreDataManager.fetchPreviousWorkoutSets(for: exercise.id),
            plusTapAction: { [weak self] in
                self?.showSetView?(exercise, nil)
            },
            showPrevious: { [weak self] in
                if self?.selectedExerciseId.value == exercise.id {
                    self?.selectedExerciseId.accept(nil)
                } else {
                    self?.selectedExerciseId.accept(exercise.id)
                }
            },
            showInfo: { [weak self] in
                self?.showExerciseInfo?(exercise)
            },
            showSetView: { [weak self] set in
                self?.showSetView?(exercise, set)
            }
        )
    }

    private func buildYesterdayRow(exercise: ExerciseModel) -> Structurable {
        return YesterdayCellModel(
            exercise: exercise,
            sets: sets.filter({ $0.exerciseId == exercise.id}),
            archive: coreDataManager.fetchPreviousWorkoutSets(for: exercise.id),
            plusTapAction: { [weak self] in
                self?.showSetView?(exercise, nil)
            },
            showPrevious: { [weak self] in
                if self?.selectedExerciseId.value == exercise.id {
                    self?.selectedExerciseId.accept(nil)
                } else {
                    self?.selectedExerciseId.accept(exercise.id)
                }
            },
            showInfo: { [weak self] in
                self?.showExerciseInfo?(exercise)
            },
            showSetView: { [weak self] set in
                self?.showSetView?(exercise, set)
            }
        )
    }

    private func updateTimerConf(_ timerConf: TimerConf) {
        var lastConf = confStorage.conf
        lastConf.timerConf = timerConf
        confStorage.updateConfiguration(lastConf)
    }

    @objc private func editTap() {
        editWorkout?(workoutId)
    }
}
