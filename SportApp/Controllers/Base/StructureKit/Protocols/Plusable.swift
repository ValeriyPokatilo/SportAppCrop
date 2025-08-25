import Foundation
import RxCocoa

protocol Plusable: AnyObject {
    var plusIsHidden: Driver<Bool> { get }
    func plusTapped()
}
