import Foundation
import StructureKit
import RxSwift
import RxCocoa

final class WorkoutListController: StructurKitController {}

final class WorkoutListViewModel: StructurKitViewModelAbstract,
                                  TableViewDidLoad {

    let title = BehaviorRelay<String?>(value: "tabBarTitleWorkoutStr".localized())
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [WorkoutCell.self, IconActionCell.self]
    let placeholderView: BehaviorRelay<UIView?> = .init(value: nil)
    var movableCells: [UITableViewCell.Type] = [WorkoutCell.self]
    var leftBarButtonItem: UIBarButtonItem?
    var rightBarButtonItem: UIBarButtonItem?

    var runWorkout: ParameterBlock<WorkoutModel>?
    var editWorkout: ParameterBlock<UUID>?
    var showWorkoutDetails: ParameterBlock<UUID?>?
    var showTemplateMenu: EmptyBlock?
    var showPurchaseView: EmptyBlock?

    private let allWorkoutList: BehaviorRelay<[WorkoutModel]> = .init(value: [])
    private let activeWorkoutList: BehaviorRelay<[WorkoutModel]> = .init(value: [])
    private let disposeBag = DisposeBag()
    private let workoutStorage = WorkoutStorage.shared

    init() {
        configureControl()
    }

    func viewDidLoad() {
        configureDynamics()
    }

    private func configureControl() {
        leftBarButtonItem = UIBarButtonItem(
            image: .templateImg,
            style: .plain,
            target: self,
            action: #selector(showTemplates)
        )

        rightBarButtonItem = UIBarButtonItem(
            image: .plusImg,
            style: .plain,
            target: self,
            action: #selector(plusTap)
        )
    }

    private func configureDynamics() {
        workoutStorage.workoutObservable
            .map { $0.filter { $0.isActive ?? true } }
            .subscribe(onNext: { [weak self] list in
                self?.activeWorkoutList.accept(list)
            })
            .disposed(by: disposeBag)

        workoutStorage.workoutObservable
            .subscribe(onNext: { [weak self] list in
                self?.allWorkoutList.accept(list)
            })
            .disposed(by: disposeBag)

        activeWorkoutList
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        if activeWorkoutList.value.isEmpty {
            placeholderView.accept(
                PlaceholderView(
                    title: "createWorkoutStr".localized(),
                    createBlock: { [weak self] in
                        self?.createNewWorkout()
                    }
                )
            )
        } else {
            placeholderView.accept(nil)

            activeWorkoutList.value.forEach { workout in
                rows.append(WorkoutCellModel(
                    workout: workout,
                    deleteSwipeAction: { [weak self] in
                        self?.deleteWorkout(by: workout.id)
                    },
                    editSwipeAction: { [weak self] in
                        self?.editWorkout?(workout.id)
                    },
                    moveWorkoutToArchive: { [weak self] in
                        self?.moveToArchive(workout: workout)
                    },
                    didSelect: { [weak self] _ in
                        self?.runWorkout?(workout)
                        return true
                    }
                ))
            }

            rows.append(
                IconActionCellModel(
                    id: "plus",
                    image: .plusCircleImg,
                    color: .systemGreen,
                    tapAction: { [weak self] in
                        self?.createNewWorkout()
                    }
                )
            )
        }

        section.rows = rows
        sections.accept([section])
    }

    func moveRows(from: Int, to: Int) {
        workoutStorage.moveWorkout(from: from, to: to)
    }

    private func moveToArchive(workout: WorkoutModel) {
        let updatedWorkout = WorkoutModel(
            id: workout.id,
            title: workout.title,
            exerciseIds: workout.exerciseIds,
            isActive: false
        )
        workoutStorage.updateWorkout(updatedWorkout)
    }

    private func deleteWorkout(by workoutId: UUID) {
        workoutStorage.removeWorkout(by: workoutId)
    }

    private func createNewWorkout() {
        if PurchaseManager.shared.rights == .all {
            showWorkoutDetails?(nil)
        } else {
            showWorkoutDetails?(nil)
        }
    }

    @objc private func showTemplates() {
        showTemplateMenu?()
    }

    @objc private func plusTap() {
        createNewWorkout()
    }
}
