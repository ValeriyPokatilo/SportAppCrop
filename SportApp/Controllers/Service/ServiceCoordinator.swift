import UIKit

final class ServiceCoordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = ServiceViewModel()
        let controller = ServiceViewController(viewModel)

        viewModel.popToRoot = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }

        navigationController.pushViewController(controller, animated: true)
    }
}
