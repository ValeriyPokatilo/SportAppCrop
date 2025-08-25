import UIKit

final class IndicatorEditCoordinator {

    private let navigationController: UINavigationController
    private let indicator: IndicatorEntity?

    init(indicator: IndicatorEntity?, navigationController: UINavigationController) {
        self.indicator = indicator
        self.navigationController = navigationController
    }

    func start() {
        let controller = IndicatorEditController(indicator: indicator)

        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve

        navigationController.present(controller, animated: true)
    }
}
