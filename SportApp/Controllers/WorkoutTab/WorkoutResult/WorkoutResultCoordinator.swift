import UIKit

final class WorkoutResultCoordinator {

    private let workoutId: UUID
    private let navigationController: UINavigationController

    init(workoutId: UUID, navigationController: UINavigationController) {
        self.workoutId = workoutId
        self.navigationController = navigationController
    }
    func start() {
        let viewModel = WorkoutResultViewModel(workoutId: workoutId)
        let controller = WorkoutResultViewController(viewModel)

        viewModel.popToRoot = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }

        navigationController.pushViewController(controller, animated: true)
    }
}
