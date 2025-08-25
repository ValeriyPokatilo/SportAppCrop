import UIKit

final class AppCoordinator {

    private let window: UIWindow
    private var tabBarController = UITabBarController()

    private var workoutListCoordinator: WorkoutListCoordinator?
    private var exercisesCoordinator: ExercisesTabCoordinator?
    private var infoTabCoordinator: InfoTabCoordinator?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        // Workout Tab
        workoutListCoordinator = WorkoutListCoordinator()
        guard let workoutNavController = workoutListCoordinator?.navigationController else {
            return
        }
        workoutListCoordinator?.start()

        let workoutTabItem = UITabBarItem(
            title: "tabBarTitleWorkoutStr".localized(),
            image: UIImage.mainTabImg?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage.mainTabImg?.withRenderingMode(.alwaysTemplate)
        )
        workoutNavController.tabBarItem = workoutTabItem

        // Exercises Tab
        exercisesCoordinator = ExercisesTabCoordinator()
        guard let exercisesNavController = exercisesCoordinator?.navigationController else {
            return
        }
        exercisesCoordinator?.start()

        let exercisesTabItem = UITabBarItem(
            title: "tabBarTitleExercisesStr".localized(),
            image: UIImage.exercisesTabImg?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage.exercisesTabImg?.withRenderingMode(.alwaysTemplate)
        )
        exercisesNavController.tabBarItem = exercisesTabItem

        // Info Tab
        infoTabCoordinator = InfoTabCoordinator()
        guard let infoNavController = infoTabCoordinator?.navigationController else {
            return
        }
        infoTabCoordinator?.start()

        let infoTabItem = UITabBarItem(
            title: "tabBarTitleInfoStr".localized(),
            image: UIImage.infoTabImg?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage.infoTabImg?.withRenderingMode(.alwaysTemplate)
        )
        infoNavController.tabBarItem = infoTabItem

        tabBarController.viewControllers = [
            workoutNavController,
            exercisesNavController,
            infoNavController
        ]
        tabBarController.tabBar.tintColor = .systemGreen
        tabBarController.tabBar.unselectedItemTintColor = .darkGray

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
