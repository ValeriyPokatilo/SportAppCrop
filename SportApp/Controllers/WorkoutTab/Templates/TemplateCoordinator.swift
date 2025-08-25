import UIKit

final class TemplateCoordinator {

    private let navigationController: UINavigationController
    private var templateDetailsCoordinator: TemplateDetailsCoordinator?
    private var purchaseCoordinator: PurchaseCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = TemplateListViewModel()
        let controller = TemplateListViewController(viewModel)

        viewModel.showDetails = { [weak self] templ in
            self?.showTemplateDetails(templ)
        }

        viewModel.showPurchaseView = { [weak self]  in
            self?.showPurchaseView()
        }

        navigationController.pushViewController(controller, animated: true)
    }

    private func showTemplateDetails(_ template: Template) {
        templateDetailsCoordinator = TemplateDetailsCoordinator(
            template: template,
            navigationController: navigationController
        )
        templateDetailsCoordinator?.start()
    }

    private func showPurchaseView() {
        purchaseCoordinator = PurchaseCoordinator(navigationController: navigationController)
        purchaseCoordinator?.start()
    }
}
