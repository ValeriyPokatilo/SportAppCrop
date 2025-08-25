import UIKit
import StoreKit
import RxSwift

final class PurchaseController: UIViewController {

    private let purchaseManager = PurchaseManager.shared

    var showAlert: DoubleParametersBlock<String, [UIAlertAction]>?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        if let transaction = purchaseManager.activetTransaction {
            view = TransactionView(parent: self, transaction: transaction)
        } else {
            view = SubscriptionsView(parent: self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
