import UIKit
import RxSwift

final class BaseNavigationController: UINavigationController, UINavigationBarDelegate, UIGestureRecognizerDelegate {

    var navigationBarDelegate: UINavigationBarDelegate?

    private let shouldPopSel = #selector(UINavigationBarDelegate.navigationBar(_:shouldPop:))
    private var defaultUnitCoordinator: DefaultUnitCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUnit()
    }

    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if let delegate = navigationBarDelegate, delegate.responds(to: shouldPopSel) {
            if delegate.navigationBar?(navigationBar, shouldPop: item) == false {
                return false
            }
        }
        return true
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let structuredVC = topViewController as? StructurKitController,
           let structuredViewModel = structuredVC.viewModel as? StructuredTableNavigation {
            return structuredViewModel.shouldReturn()
        }
        return true
    }

    private func checkUnit() {
        if ConfStorage.shared.conf.defaultUnit == .unknow {
            defaultUnitCoordinator = DefaultUnitCoordinator(
                navigationController: self
            )
            defaultUnitCoordinator?.start()
        }
    }
}
