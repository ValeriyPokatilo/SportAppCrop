import UIKit

final class IndicatorDetailsCoordinator {

    private let navigationController: UINavigationController
    private var recordEditCoordinator: RecordEditCoordinator?

    private let indicator: IndicatorEntity

    init(navigationController: UINavigationController, indicator: IndicatorEntity) {
        self.navigationController = navigationController
        self.indicator = indicator
    }

    func start() {
        let viewModel = IndicatorDetailsViewModel(indicator: indicator)
        let controller = IndicatorDetailsViewController(viewModel)

        viewModel.recordEdit = { [weak self] record, indicator in
            self?.showRecordEdit(record, indicator: indicator)
        }

        navigationController.pushViewController(controller, animated: true)
    }

    private func showRecordEdit(_ record: RecordEntity?, indicator: IndicatorEntity?) {
        recordEditCoordinator = RecordEditCoordinator(
            indicator: indicator,
            record: record,
            navigationController: navigationController
        )
        recordEditCoordinator?.start()
    }
}
