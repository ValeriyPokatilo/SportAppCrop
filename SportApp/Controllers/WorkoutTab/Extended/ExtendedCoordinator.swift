import UIKit

final class ExtendedCoordinator {

    private let navigationController: UINavigationController
    private let workoutId: UUID
    private var exerciseInfoCoordinator: ExerciseInfoCoordinator?
    private var workoutResultCoordinator: WorkoutResultCoordinator?
    private var workoutEditCoordinator: WorkoutEditCoordinator?

    init(navigationController: UINavigationController, workoutId: UUID) {
        self.navigationController = navigationController
        self.workoutId = workoutId
    }
    func start() {
        let viewModel = ExtendedViewModel(workoutId: workoutId)
        let controller = ExtendedViewController(viewModel)

        viewModel.showSetView = { [weak self] exercise, set, plan in
            let controller: UIViewController

            if exercise.unitType == .timer {
                controller = ExtendedTimerController(exercise: exercise, set: set)
            } else {
                controller = ExtendedSetController(exercise: exercise, set: set, isReal: true, plan: plan)
            }

            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
            self?.navigationController.present(controller, animated: true)
        }

        viewModel.showExerciseInfo = { [weak self] exercise in
            self?.showExerciseInfo(exercise: exercise)
        }

        viewModel.showResults = { [weak self] id in
            self?.showResults(id: id)
        }

        viewModel.editWorkout = { [weak self] id in
            self?.showWorkout(id)
        }

        navigationController.pushViewController(controller, animated: true)
    }

    private func showExerciseInfo(exercise: ExerciseModel) {
        exerciseInfoCoordinator = ExerciseInfoCoordinator(
            navigationController: navigationController,
            exercise: exercise
        )
        exerciseInfoCoordinator?.start()
    }

    private func showResults(id: UUID) {
        workoutResultCoordinator = WorkoutResultCoordinator(
            workoutId: id,
            navigationController: navigationController
        )
        workoutResultCoordinator?.start()
    }

    private func showWorkout(_ workoutId: UUID?) {
        workoutEditCoordinator = WorkoutEditCoordinator(
            workoutId: workoutId,
            navigationController: navigationController
        )
        workoutEditCoordinator?.start()
    }
}
