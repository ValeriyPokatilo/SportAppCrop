import UIKit

final class ExerciseEditCoordinator {

    private let navigationController: UINavigationController
    private var muscleGroupsCoordinator: MuscleGroupsCoordinator?
    private var equipmentCoordinator: EquipmentCoordinator?

    private let exercise: ExerciseModel?

    init(navigationController: UINavigationController, exercise: ExerciseModel?) {
        self.navigationController = navigationController
        self.exercise = exercise
    }

    func start() {
        let viewModel = ExerciseEditViewModel(exercise: exercise)
        let controller = ExerciseEditViewController(viewModel)

        viewModel.showMuscleMenu = { [weak self] selected in
            self?.showMuscleMenu(
                selected: selected,
                selectBlock: { [weak viewModel] group in
                    viewModel?.changeGroup(group)
                })
        }

        viewModel.showEquipmentMenu = { [weak self] selected in
            self?.showEquipmentMenu(
                selected: selected,
                selectBlock: { [weak viewModel] group in
                    viewModel?.changeGroup(group)
                })
        }

        viewModel.popViewController = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }

        navigationController.pushViewController(controller, animated: true)
    }

    private func showMuscleMenu(
        selected: [MuscleGroup],
        selectBlock: @escaping ParameterBlock<[MuscleGroup]>
    ) {
        muscleGroupsCoordinator = MuscleGroupsCoordinator(
            selectedGroups: selected,
            selectBlock: selectBlock,
            navigationController: navigationController
        )
        muscleGroupsCoordinator?.start()
    }

    private func showEquipmentMenu(
        selected: [Equipment],
        selectBlock: @escaping ParameterBlock<[Equipment]>
    ) {
        equipmentCoordinator = EquipmentCoordinator(
            selectedGroups: selected,
            selectBlock: selectBlock,
            navigationController: navigationController
        )
        equipmentCoordinator?.start()
    }
}
