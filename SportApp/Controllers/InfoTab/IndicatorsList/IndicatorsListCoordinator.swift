import UIKit

final class IndicatorsListCoordinator {

    private let navigationController: UINavigationController
    private var indicatorEditCoordinator: IndicatorEditCoordinator?
    private var recordEditCoordinator: RecordEditCoordinator?
    private var purchaseCoordinator: PurchaseCoordinator?
    private var indicatorDetailsCoordinator: IndicatorDetailsCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = IndicatorsListViewModel()
        let controller = IndicatorsListViewController(viewModel)

        viewModel.indicatorEdit = { [weak self] indicator in
            self?.showIndicatorEdit(indicator)
        }

        viewModel.recordEdit = { [weak self] record, indicator in
            self?.showRecordEdit(record, indicator: indicator)
        }

        viewModel.showCreateIndicator = { [weak self] in
            self?.showIndicatorEdit(nil)
        }

        viewModel.showPurchaseView = { [weak self] in
            self?.showPurchaseView()
        }

        viewModel.showIndicatorDetails = { [weak self] indicator in
            self?.showIndicatorDetails(indicator: indicator)
        }

        navigationController.pushViewController(controller, animated: true)
    }

    private func showIndicatorEdit(_ indicator: IndicatorEntity?) {
        indicatorEditCoordinator = IndicatorEditCoordinator(
            indicator: indicator,
            navigationController: navigationController
        )
        indicatorEditCoordinator?.start()
    }

    private func showRecordEdit(_ record: RecordEntity?, indicator: IndicatorEntity?) {
        recordEditCoordinator = RecordEditCoordinator(
            indicator: indicator,
            record: record,
            navigationController: navigationController
        )
        recordEditCoordinator?.start()
    }

    private func showPurchaseView() {
        purchaseCoordinator = PurchaseCoordinator(navigationController: navigationController)
        purchaseCoordinator?.start()
    }

    private func showIndicatorDetails(indicator: IndicatorEntity) {
        indicatorDetailsCoordinator = IndicatorDetailsCoordinator(
            navigationController: navigationController,
            indicator: indicator
        )
        indicatorDetailsCoordinator?.start()
    }
}
