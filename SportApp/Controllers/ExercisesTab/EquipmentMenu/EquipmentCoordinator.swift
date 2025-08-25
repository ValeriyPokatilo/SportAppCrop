import UIKit

final class EquipmentCoordinator {

    private let navigationController: UINavigationController
    private let selectBlock: ParameterBlock<[Equipment]>
    private let selectedGroups: [Equipment]
    private let isMultipleSelection: Bool

    init(
        selectedGroups: [Equipment],
        selectBlock: @escaping ParameterBlock<[Equipment]>,
        isMultipleSelection: Bool = true,
        navigationController: UINavigationController
    ) {
        self.selectedGroups = selectedGroups
        self.selectBlock = selectBlock
        self.isMultipleSelection = isMultipleSelection
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = EquipmentViewModel(
            selectedGroups: selectedGroups,
            isMultipleSelection: isMultipleSelection
        )
        let controller = EquipmentViewController(viewModel)

        viewModel.selectBlock = { [weak self] group in
            self?.selectBlock(group)
            controller.dismiss(animated: true)
        }

        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.custom { _ in CGFloat.screenWidth * 1.25 }]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        navigationController.present(controller, animated: true)
    }
}
