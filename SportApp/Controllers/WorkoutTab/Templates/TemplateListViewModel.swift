import Foundation
import StructureKit
import RxCocoa
import RxSwift

final class TemplateListViewController: StructurKitController {}

final class TemplateListViewModel: StructurKitViewModelAbstract, TableViewDidLoad {

    let title = BehaviorRelay<String?>(value: "tabBarTitleWorkoutStr".localized())
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [
        TemplateCell.self,
        ArchiveWorkoutCell.self,
        TemplateSegmentedCell.self
    ]
    var showAlert: BehaviorRelay<AlertConfiguration?> = .init(value: nil)
    var showDetails: ParameterBlock<Template>?
    var showPurchaseView: EmptyBlock?

    private let storage: [Template] = [
        .gymStart,
        .homeStart
    ]
    private let currentIndex = BehaviorRelay(value: 0)
    private let workoutStorage = WorkoutStorage.shared
    private let workoutList: BehaviorRelay<[WorkoutModel]> = .init(value: [])
    private let disposeBag = DisposeBag()

    func viewDidLoad() {
        configureDynamics()
    }

    private func configureDynamics() {
        currentIndex.subscribe(onNext: { [weak self] _ in
            self?.buildCells()
        })
        .disposed(by: disposeBag)

        workoutStorage.workoutObservable
            .map { $0.filter { !($0.isActive ?? true) } }
            .bind(to: workoutList)
            .disposed(by: disposeBag)

        workoutList
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        rows.append(
            TemplateSegmentedCellModel(
                id: "header",
                index: 0,
                valueChanged: { [weak self] value in
                    self?.currentIndex.accept(value)
                }
            ))

        switch currentIndex.value {
        case 0:
            storage.forEach { template in
                rows.append(TemplateCellModel(
                    id: template.id,
                    template: template,
                    didSelect: { [weak self] _ in
                        if PurchaseManager.shared.rights == .all {
                            self?.showDetails?(template)
                        } else {
                            self?.showPurchaseView?()
                        }
                        return true
                    }))
            }
        case 1:
            workoutList.value.forEach { workout in
                rows.append(ArchiveWorkoutCellModel(
                    workout: workout,
                    deleteSwipeAction: { [weak self] in
                        self?.deleteWorkout(by: workout.id)
                    },
                    moveWorkoutFromArchive: { [weak self] in
                        self?.moveFromArchive(workout: workout)
                    },
                    didSelect: { [weak self] _ in
                        self?.moveFromArchiveAlert(workout: workout)
                        return true
                    }
                ))
            }
        default:
            break
        }

        section.rows = rows
        sections.accept([section])
    }

    private func deleteWorkout(by workoutId: UUID) {
        workoutStorage.removeWorkout(by: workoutId)
    }

    private func moveFromArchive(workout: WorkoutModel) {
        let updatedWorkout = WorkoutModel(
            id: workout.id,
            title: workout.title,
            exerciseIds: workout.exerciseIds,
            isActive: true
        )
        workoutStorage.updateWorkout(updatedWorkout)
    }

    private func moveFromArchiveAlert(workout: WorkoutModel) {
        let alertConfig = AlertConfiguration(
            title: "restoreWorkoutStr".localized(),
            message: nil,
            preferredStyle: .alert,
            actions: [
                UIAlertAction(
                    title: "cancelStr".localized(),
                    style: .destructive
                ),
                UIAlertAction(
                    title: "yesStr".localized(),
                    style: .default
                ) { [weak self] _ in
                    self?.moveFromArchive(workout: workout)
                }
            ]
        )
        showAlert.accept(alertConfig)
    }
}
