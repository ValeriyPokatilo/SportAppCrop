import UIKit

final class ExerciseListCoordinator {

    var navigationController = UINavigationController()
    private let selectBlock: ParameterBlock<ExerciseModel>?

    private var exerciseEditCoordinator: ExerciseEditCoordinator?
    private var muscleGroupsCoordinator: MuscleGroupsCoordinator?
    private var equipmentCoordinator: EquipmentCoordinator?
    private var unitTypeCoordinator: UnitTypeCoordinator?
    private var purchaseCoordinator: PurchaseCoordinator?

    init(
        navigationController: UINavigationController,
        selectBlock: @escaping ParameterBlock<ExerciseModel>
    ) {
        self.navigationController = navigationController
        self.selectBlock = selectBlock
    }

    func start() {
        let viewModel = ExerciseListViewModel()
        let controller = ExerciseListViewController(viewModel)

        viewModel.selectBlock = { [weak self] selectedExercise in
            self?.selectBlock?(selectedExercise)
            self?.navigationController.popViewController(animated: true)
        }

        viewModel.showPurchaseView = { [weak self]  in
            self?.showPurchaseView()
        }

        viewModel.createBlock = { [weak self] in
            self?.showCreateExercise()
        }

        viewModel.editBlock = { [weak self] exercise in
            self?.showEditExercise(exercise)
        }

        viewModel.equipmentTap = { [weak self] in
            self?.showEquipmentMenu(
                selected: [],
                selectBlock: { [weak viewModel] eqs in
                    if !eqs.isEmpty {
                        viewModel?.setEquipment(eqs.first)
                    }
                })
        }

        viewModel.muscleTap = { [weak self] in
            self?.showMuscleMenu(
                selected: [],
                selectBlock: { [weak viewModel] msc in
                    if !msc.isEmpty {
                        viewModel?.setMuscle(msc.first)
                    }
                })
        }

        viewModel.unitTypeTap = { [weak self] in
            self?.showUnitTypeMenu(selectBlock: { [weak viewModel] ut in
                viewModel?.setUnitType(ut)
            })
        }

        navigationController.pushViewController(controller, animated: true)
    }

    private func showCreateExercise() {
        exerciseEditCoordinator = ExerciseEditCoordinator(
            navigationController: navigationController,
            exercise: nil
        )
        exerciseEditCoordinator?.start()
    }

    private func showEditExercise(_ exercise: ExerciseModel) {
        exerciseEditCoordinator = ExerciseEditCoordinator(
            navigationController: navigationController,
            exercise: exercise
        )
        exerciseEditCoordinator?.start()
    }

    private func showEquipmentMenu(
        selected: [Equipment],
        selectBlock: @escaping ParameterBlock<[Equipment]>
    ) {
        equipmentCoordinator = EquipmentCoordinator(
            selectedGroups: selected,
            selectBlock: selectBlock,
            isMultipleSelection: false,
            navigationController: navigationController
        )
        equipmentCoordinator?.start()
    }

    private func showMuscleMenu(
        selected: [MuscleGroup],
        selectBlock: @escaping ParameterBlock<[MuscleGroup]>
    ) {
        muscleGroupsCoordinator = MuscleGroupsCoordinator(
            selectedGroups: selected,
            selectBlock: selectBlock,
            isMultipleSelection: false,
            navigationController: navigationController
        )
        muscleGroupsCoordinator?.start()
    }

    private func showUnitTypeMenu(selectBlock: @escaping ParameterBlock<UnitType>) {
        unitTypeCoordinator = UnitTypeCoordinator(
            selectBlock: selectBlock,
            navigationController: navigationController
        )
        unitTypeCoordinator?.start()
    }

    private func showPurchaseView() {
        purchaseCoordinator = PurchaseCoordinator(navigationController: navigationController)
        purchaseCoordinator?.start()
    }
}
