import Foundation
import StructureKit
import RxSwift
import RxCocoa

final class WorkoutResultViewController: StructurKitController {}

final class WorkoutResultViewModel: StructurKitViewModelAbstract, TableViewDidLoad {

    var title = BehaviorRelay<String?>(value: "resultsStr".localized())
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [
        ExerciseResultCell.self,
        ActionCell.self
    ]
    var rightBarButtonItem: UIBarButtonItem?

    var showResults: EmptyBlock?
    var popToRoot: EmptyBlock?

    private let workoutId: UUID
    private var sets: [SetEntity] = []
    private let workout = BehaviorRelay<WorkoutModel?>(value: nil)
    private let exercisesList = BehaviorRelay(value: [ExerciseModel]())

    private let coreDataManager = CoreDataManager.shared
    private let workoutStorage = WorkoutStorage.shared
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
            image: .checkOkImg,
            style: .plain,
            target: self,
            action: #selector(okTap)
        )
    }

    private func configureDynamics() {
        workoutStorage.workoutObservable
            .compactMap { [weak self] workouts in
                workouts.first { $0.id == self?.workoutId }
            }
            .subscribe(onNext: { [weak self] workout in
                self?.workout.accept(workout)
            })
            .disposed(by: disposeBag)

        workout
            .compactMap { $0?.getExercises() }
            .subscribe(onNext: { [weak self] exercises in
                self?.exercisesList.accept(exercises)
            })
            .disposed(by: disposeBag)

        coreDataManager.setsObservable
            .subscribe(onNext: { [weak self] sets in
                self?.sets = sets
                self?.buildCells()
            })
            .disposed(by: disposeBag)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        exercisesList.value.forEach { exercise in
            rows.append(
                ExerciseResultCellModel(
                    exercise: exercise,
                    sets: sets.filter({ $0.exerciseId == exercise.id}),
                    archive: coreDataManager.fetchPreviousWorkoutSets(for: exercise.id)
                )
            )
        }

        rows.append(
            ActionCellModel(
                id: "ok",
                title: "okStr".localized(),
                color: .systemGreen,
                didSelect: { [weak self] _ in
                    self?.popToRoot?()
                    return true
                }
            )
        )

        section.rows = rows
        sections.accept([section])
    }

    @objc private func okTap() {
        popToRoot?()
    }
}
