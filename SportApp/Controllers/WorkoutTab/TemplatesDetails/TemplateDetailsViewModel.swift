import Foundation
import StructureKit
import RxCocoa

final class TemplateDetailsViewController: StructurKitController {}

final class TemplateDetailsViewModel: StructurKitViewModelAbstract, TableViewDidLoad {

    let title: BehaviorRelay<String?> = .init(value: "")
    let sections = BehaviorRelay(value: [StructureSection]())
    let registerClasses: [UITableViewCell.Type] = [
        LabelCell.self,
        ExerciseListCell.self,
        ActionCell.self
    ]

    var popToRoot: EmptyBlock?
    var showDetails: ParameterBlock<ExerciseModel>?

    private let template: Template
    private let workoutStorage = WorkoutStorage.shared

    init(template: Template) {
        self.template = template
        title.accept(template.localizedTitle)
    }

    func viewDidLoad() {
        buildCells()
    }

    private func buildCells() {
        var tableSections = [StructureSection]()

        tableSections.append(createDescSection())

        template.workouts.forEach { workout in
            tableSections.append(createWorkoutSection(workout: workout))
        }

        tableSections.append(createActionSection())

        sections.accept(tableSections)
    }

    private func createDescSection() -> StructureSection {
        var section = StructureSection(identifier: "description")
        var rows = [Structurable]()
        rows.append(LabelCellModel(id: "desc", text: template.localizedDesc))
        let level = "levelStr".localized() + ": " + template.level.localizedTitle
        rows.append(LabelCellModel(id: "desc", text: level))

        section.rows = rows
        return section
    }

    private func createWorkoutSection(workout: WorkoutModel) -> StructureSection {
        var rows = [Structurable]()
        var section = StructureSection(identifier: workout.id)

        rows.append(LabelCellModel(
            id: workout.id,
            text: workout.title,
            size: 18,
            weight: .bold,
            alignment: .center
        ))

        workout.getExercises().forEach { exercise in
            rows.append(
                ExerciseListCellModel(
                    exercise: exercise,
                    deleteTitle: "",
                    deleteSwipeAction: nil,
                    editSwipeAction: nil,
                    canEdit: false,
                    didSelect: { [weak self] _ in
                        self?.showDetails?(exercise)
                        return true
                    }
                ))
        }
        section.rows = rows

        return section
    }

    private func createActionSection() -> StructureSection {
        var section = StructureSection(identifier: "action")
        section.rows = [ActionCellModel(
            id: "add",
            title: "addStr".localized(),
            color: .systemGreen,
            didSelect: { [weak self] _ in
                if let title = self?.template.titleRu {
                    AnalyticsManager.shared.logTemplateUsed(templateID: title)
                }
                self?.addWorkouts()
                self?.popToRoot?()
                return true
            }
        )]
        return section
    }

    private func addWorkouts() {
        template.workouts.forEach { workout in
            workoutStorage.addWorkoutFromTempl(workout)
        }
    }
}
