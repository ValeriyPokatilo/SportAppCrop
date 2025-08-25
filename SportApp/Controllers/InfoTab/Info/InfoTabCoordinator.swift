import Foundation

final class InfoTabCoordinator {

    var navigationController = BaseNavigationController()

    private var indicatorsListCoordinator: IndicatorsListCoordinator?
    private var defaultUnitCoordinator: DefaultUnitCoordinator?
    private var serviceCoordinator: ServiceCoordinator?
    private var purchaseCoordinator: PurchaseCoordinator?

    func start() {
        let viewModel = InfoTabViewModel()
        let controller = InfoTabViewController(viewModel)

        viewModel.showIndicatorsList = { [weak self] in
            self?.showIndicatorsList()
        }

        viewModel.showDefaultUnit = { [weak self] in
            self?.showDefaultUnit()
        }

        viewModel.showServiceMenu = { [weak self] in
            self?.showServiceMenu()
        }

        viewModel.showPurchaseMenu = { [weak self] in
            self?.showPurchaseMenu()
        }

        navigationController.pushViewController(controller, animated: false)
    }

    private func showIndicatorsList() {
        indicatorsListCoordinator = IndicatorsListCoordinator(
            navigationController: navigationController
        )
        indicatorsListCoordinator?.start()
    }

    private func showDefaultUnit() {
        defaultUnitCoordinator = DefaultUnitCoordinator(
            navigationController: navigationController
        )
        defaultUnitCoordinator?.start()
    }

    private func showServiceMenu() {
        serviceCoordinator = ServiceCoordinator(navigationController: navigationController)
        serviceCoordinator?.start()
    }

    private func showPurchaseMenu() {
        purchaseCoordinator = PurchaseCoordinator(navigationController: navigationController)
        purchaseCoordinator?.start()
    }
}
