import Foundation
import StructureKit
import RxSwift
import RxCocoa

final class ServiceViewController: StructurKitController {}

// swiftlint:disable line_length
// swiftlint:disable function_body_length
final class ServiceViewModel: StructurKitViewModelAbstract {

    let title = BehaviorRelay<String?>(value: "tabBarTitleInfoStr".localized())
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [ActionCell.self, LabelCell.self]

    var popToRoot: EmptyBlock?

    private let disposeBag = DisposeBag()
    private let workouts = BehaviorRelay(value: [WorkoutModel]())
    private let exercises = BehaviorRelay(value: [ExerciseModel]())
    private let sets = BehaviorRelay(value: [SetEntity]())
    private let workoutStorage = WorkoutStorage.shared
    private let exerciseStorage = ExerciseStorage.shared
    private let coreDataManager = CoreDataManager.shared
    private let mockExerciseStorage = MockExerciseStorage.shared

    init() {
        configureDynamics()
    }

    private func configureDynamics() {
        workoutStorage.workoutObservable
            .bind(to: workouts)
            .disposed(by: disposeBag)

        exerciseStorage.exercisesObservable
            .subscribe(onNext: { [weak self] items in
                self?.exercises.accept(items + (self?.mockExerciseStorage.exerciseList ?? []))
            })
            .disposed(by: disposeBag)

        coreDataManager.setsObservable
            .bind(to: sets)
            .disposed(by: disposeBag)

        exercises
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)

        sets
            .subscribe(onNext: { [weak self] _ in
                self?.buildCells()
            })
            .disposed(by: disposeBag)
    }

    private func buildCells() {
        var rows = [Structurable]()
        var section = StructureSection(identifier: "section")

        rows.append(ActionCellModel(
            id: "shitSets",
            title: "Сдвинуть подходы назад",
            color: .systemGreen,
            didSelect: { [weak self] _ in
                CoreDataManager.shared.shiftAllSetsOneDayBack()
                self?.popToRoot?()
                return true
            }
        ))

        rows.append(ActionCellModel(
            id: "shiftIndicators",
            title: "Сдвинуть замеры назад",
            color: .systemGreen,
            didSelect: { [weak self] _ in
                IndicatorsStorage.shared.shiftRecordsBy(days: 6)
                self?.popToRoot?()
                return true
            }
        ))

        rows.append(LabelCellModel(
            id: "workouts",
            text: "Все тренировки (\(workouts.value.count))",
            size: 16,
            didSelect: { _ in
                // hidden
            return true
            }
        ))

        rows.append(LabelCellModel(
            id: "exercises",
            text: "Все упражнения (\(exercises.value.count))",
            size: 16,
            didSelect: { _ in
                // hidden
            return true
            }
        ))

        rows.append(LabelCellModel(
            id: "sets",
            text: "Все подходы (\(sets.value.count))",
            size: 16,
            didSelect: { _ in
                // hidden
            return true
        }))

        section.rows = rows
        sections.accept([section])
    }
}
// swiftlint:enable line_length
// swiftlint:enable function_body_length
