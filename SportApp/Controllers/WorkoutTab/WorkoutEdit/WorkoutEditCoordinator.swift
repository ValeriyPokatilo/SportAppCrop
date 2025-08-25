import UIKit

final class WorkoutEditCoordinator {

    private let navigationController: UINavigationController
    private let workoutId: UUID?
    private var exerciseListCoordinator: ExerciseListCoordinator?
    private var exerciseEditCoordinator: ExerciseEditCoordinator?

    init(
        workoutId: UUID? = nil,
        navigationController: UINavigationController
    ) {
        self.workoutId = workoutId
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = WorkoutEditViewModel(workoutId: workoutId)
        let controller = WorkoutEditViewController(viewModel)

        viewModel.showExerciseList = { [weak self] in
            self?.showExerciseList(selectBlock: { exercise in
                viewModel.appendExercise(exercise)
            })
        }

        viewModel.showEditExercise = { [weak self] exercise in
            self?.showEditExercise(exercise)
        }

        viewModel.popViewController = { [weak self] in
            self?.popViewController()
        }

        navigationController.pushViewController(controller, animated: true)
    }

    private func showExerciseList(selectBlock: @escaping ParameterBlock<ExerciseModel>) {
        exerciseListCoordinator = ExerciseListCoordinator(
            navigationController: navigationController,
            selectBlock: { exercise in
                selectBlock(exercise)
            }
        )
        exerciseListCoordinator?.start()
    }

    private func popViewController() {
        navigationController.popViewController(animated: true)
    }

    private func showEditExercise(_ exercise: ExerciseModel) {
        exerciseEditCoordinator = ExerciseEditCoordinator(
            navigationController: navigationController,
            exercise: exercise
        )
        exerciseEditCoordinator?.start()
    }
}
