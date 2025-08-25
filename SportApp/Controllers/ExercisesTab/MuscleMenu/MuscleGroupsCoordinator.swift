import UIKit

final class MuscleGroupsCoordinator {

    private let navigationController: UINavigationController
    private let selectBlock: ParameterBlock<[MuscleGroup]>
    private let selectedGroups: [MuscleGroup]
    private let isMultipleSelection: Bool

    init(
        selectedGroups: [MuscleGroup],
        selectBlock: @escaping ParameterBlock<[MuscleGroup]>,
        isMultipleSelection: Bool = true,
        navigationController: UINavigationController
    ) {
        self.selectedGroups = selectedGroups
        self.selectBlock = selectBlock
        self.isMultipleSelection = isMultipleSelection
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MuscleGroupsViewModel(
            selectedGroups: selectedGroups,
            isMultipleSelection: isMultipleSelection
        )
        let controller = MuscleGroupsViewController(viewModel)

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
