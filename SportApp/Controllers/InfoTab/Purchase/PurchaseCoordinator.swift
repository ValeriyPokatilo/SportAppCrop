import UIKit

final class PurchaseCoordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let controller = PurchaseController()

        controller.showAlert = { [weak self] title, actions in
            self?.showAlert(title: title, actions: actions, controller: controller)
        }

        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve

        navigationController.present(controller, animated: true)
    }

    private func showAlert(
        title: String,
        actions: [UIAlertAction],
        controller: UIViewController
    ) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )

        actions.forEach {
            alert.addAction($0)
        }

        controller.present(alert, animated: true)
    }
}
