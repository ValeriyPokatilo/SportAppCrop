import Foundation

enum AppEnvironment {
    case debug
    case testFlight
    case appStore

    static var current: AppEnvironment {
        #if DEBUG
        return .debug
        #else
        if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
            return .testFlight
        } else {
            return .appStore
        }
        #endif
    }
}
