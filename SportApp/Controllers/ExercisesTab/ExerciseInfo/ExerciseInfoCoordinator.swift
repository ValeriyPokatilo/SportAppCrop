import UIKit

final class ExerciseInfoCoordinator {

    private let navigationController: UINavigationController
    private let exercise: ExerciseModel
    private var exerciseEditCoordinator: ExerciseEditCoordinator?

    init(navigationController: UINavigationController, exercise: ExerciseModel) {
        self.navigationController = navigationController
        self.exercise = exercise
    }

    func start() {
        let viewModel = ExerciseInfoViewModel(exercise: exercise)
        let controller = ExerciseInfoViewController(viewModel)

        viewModel.sendReport = { [weak self] exercise in
            self?.sendReport(exercise: exercise)
        }

        viewModel.showEdit = { [weak self] exercise in
            self?.showExerciseEdit(exercise: exercise)
        }

        navigationController.pushViewController(controller, animated: true)
    }

    private func sendReport(exercise: ExerciseModel) {
        let controller = MessageViewController(exercise: exercise)

        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve

        navigationController.present(controller, animated: true)
    }

    private func showExerciseEdit(exercise: ExerciseModel) {
        exerciseEditCoordinator = ExerciseEditCoordinator(
            navigationController: navigationController,
            exercise: exercise
        )
        exerciseEditCoordinator?.start()
    }
}
