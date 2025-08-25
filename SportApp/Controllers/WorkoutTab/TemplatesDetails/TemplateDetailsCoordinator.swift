import UIKit

final class TemplateDetailsCoordinator {

    private let navigationController: UINavigationController
    private let template: Template
    private var exerciseInfoCoordinator: ExerciseInfoCoordinator?

    init(template: Template, navigationController: UINavigationController) {
        self.template = template
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = TemplateDetailsViewModel(template: template)
        let controller = TemplateDetailsViewController(viewModel)

        viewModel.popToRoot = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }

        viewModel.showDetails = { [weak self] exercise in
            self?.showExerciseDetails(exercise)
        }

        navigationController.pushViewController(controller, animated: true)
    }

    private func showExerciseDetails(_ exercise: ExerciseModel) {
        exerciseInfoCoordinator = ExerciseInfoCoordinator(
            navigationController: navigationController,
            exercise: exercise
        )
        exerciseInfoCoordinator?.start()
    }
}
