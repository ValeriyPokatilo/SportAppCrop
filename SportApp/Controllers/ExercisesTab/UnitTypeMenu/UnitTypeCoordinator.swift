import UIKit

final class UnitTypeCoordinator {

    private let navigationController: UINavigationController
    private let selectBlock: ParameterBlock<UnitType>

    init(
        selectBlock: @escaping ParameterBlock<UnitType>,
        navigationController: UINavigationController
    ) {
        self.selectBlock = selectBlock
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = UnitTypeViewModel()
        let controller = UnitTypeViewController(viewModel)

        viewModel.selectBlock = { [weak self] group in
            self?.selectBlock(group)
            controller.dismiss(animated: true)
        }

        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.custom { _ in CGFloat.screenWidth / 2 }]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        navigationController.present(controller, animated: true)
    }
}
