import Foundation
import StoreKit

final class PurchaseManager: NSObject {

    static let shared = PurchaseManager()

    private let confStorage = ConfStorage.shared
    private let productIds = [
        Subscriptions.proWeekly.rawValue,
        Subscriptions.proMonth.rawValue,
        Subscriptions.proAnnual.rawValue
    ]

    private(set) var activetTransaction: Transaction?

    private(set) var rights: Rights = .nothing {
        willSet {
            var conf = confStorage.conf
            conf.rights = newValue
            confStorage.updateConfiguration(conf)
        }
    }

    private(set) var products: [Product] = []

    private var productsLoaded = false
    private var updates: Task<Void, Never>?

    override private init() {
        super.init()
        loadRights()
        updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)

        Task.detached {
            await self.updatePurchasedProducts()
        }
    }

    func loadRights() {
        rights = confStorage.conf.rights
    }

    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }

    func purchase(product: Product, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        await transaction.finish()
                        await updatePurchasedProducts()
                        AnalyticsManager.shared.logSubscriptionPurchased(product: product)
                        completion(.success(()))
                    case .unverified(_, let error):
                        // TODO: - log error
                        completion(.failure(error))
                    }
                case .userCancelled:
                    let error = NSError(
                        domain: "xl.app",
                        code: 404,
                        userInfo: [
                            NSLocalizedDescriptionKey: "cancelledStr".localized()
                        ]
                    )
                    completion(.failure(error))
                case .pending:
                    break
                @unknown default:
                    break
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }

            if transaction.revocationDate == nil {
                await MainActor.run {
                    self.activetTransaction = transaction
                    self.rights = .all
                }
            } else {
                await MainActor.run {
                    self.rights = .nothing
                }
            }
            return
        }

        await MainActor.run {
            self.rights = .nothing
        }
    }

    func restorePurchases(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            var hasActiveSubscription = false

            for await result in Transaction.currentEntitlements {
                guard case .verified(let transaction) = result else { continue }

                if transaction.revocationDate == nil {
                    await MainActor.run {
                        self.activetTransaction = transaction
                        self.rights = .all
                    }
                    hasActiveSubscription = true
                    break
                }
            }

            if hasActiveSubscription {
                await MainActor.run {
                    completion(.success(()))
                }
            } else {
                await MainActor.run {
                    self.rights = .nothing
                    let error = NSError(
                        domain: "xl.app",
                        code: 404,
                        userInfo: [
                            NSLocalizedDescriptionKey: "restorErrorStr".localized()
                        ]
                    )
                    completion(.failure(error))
                }
            }
        }
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }

    deinit {
        updates?.cancel()
        SKPaymentQueue.default().remove(self)
    }
}

// MARK: - StoreKit 1 support
extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(
        _ queue: SKPaymentQueue,
        updatedTransactions transactions: [SKPaymentTransaction]
    ) {}

    func paymentQueue(_ queue: SKPaymentQueue,
                      shouldAddStorePayment payment: SKPayment,
                      for product: SKProduct
    ) -> Bool {
        return true
    }
}
