import UIKit

final class WorkoutListCoordinator {

    let navigationController = BaseNavigationController()

    private var todayCoordinator: TodayCoordinator?
    private var extendedCoordinator: ExtendedCoordinator?
    private var workoutEditCoordinator: WorkoutEditCoordinator?
    private var templateCoordinator: TemplateCoordinator?
    private var purchaseCoordinator: PurchaseCoordinator?

    func start() {
        let viewModel = WorkoutListViewModel()
        let controller = WorkoutListController(viewModel)

        viewModel.runWorkout = { [weak self] workout in
            // TODO: -
            // *** self?.runWorkout(workout)
            self?.runExtended(workout)
        }

        viewModel.editWorkout = { [weak self] id in
            self?.showWorkout(id)
        }

        viewModel.showWorkoutDetails = { [weak self] id in
            self?.showWorkout(id)
        }

        viewModel.showTemplateMenu = { [weak self] in
            self?.showTemplateMenu()
        }

        viewModel.showPurchaseView = { [weak self]  in
            self?.showPurchaseView()
        }

        navigationController.pushViewController(controller, animated: true)
    }

    private func runWorkout(_ workout: WorkoutModel) {
        todayCoordinator = TodayCoordinator(
            navigationController: navigationController,
            workoutId: workout.id
        )
        todayCoordinator?.start()
    }

    private func runExtended(_ workout: WorkoutModel) {
        extendedCoordinator = ExtendedCoordinator(
            navigationController: navigationController,
            workoutId: workout.id
        )
        extendedCoordinator?.start()
    }

    private func showWorkout(_ workoutId: UUID?) {
        workoutEditCoordinator = WorkoutEditCoordinator(
            workoutId: workoutId,
            navigationController: navigationController
        )
        workoutEditCoordinator?.start()
    }

    private func showTemplateMenu() {
        templateCoordinator = TemplateCoordinator(
            navigationController: navigationController
        )
        templateCoordinator?.start()
    }

    private func showPurchaseView() {
        purchaseCoordinator = PurchaseCoordinator(navigationController: navigationController)
        purchaseCoordinator?.start()
    }
}
