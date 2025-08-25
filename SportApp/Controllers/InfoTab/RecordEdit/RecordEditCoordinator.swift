import UIKit

final class RecordEditCoordinator {

    private let navigationController: UINavigationController
    private let indicator: IndicatorEntity?
    private let record: RecordEntity?

    init(
        indicator: IndicatorEntity?,
        record: RecordEntity?,
        navigationController: UINavigationController
    ) {
        self.record = record
        self.indicator = indicator
        self.navigationController = navigationController
    }

    func start() {
        let controller = RecordEditController(record: record, indicator: indicator)

        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve

        navigationController.present(controller, animated: true)
    }
}
