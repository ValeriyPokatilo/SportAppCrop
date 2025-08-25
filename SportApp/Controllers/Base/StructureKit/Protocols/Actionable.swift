import UIKit
import RxCocoa

protocol Actionable: AnyObject {
    var actionTitle: String { get }
    
    var actionTitleColor: UIColor { get }
    
    var actionBkgColor: UIColor { get }

    var actionEnabled: Driver<Bool> { get }

    var actionIsHidden: Driver<Bool> { get }

    func actionTapped()
}

extension Actionable {
    var actionTitleColor: UIColor {
        .white
    }
    
    var actionBkgColor: UIColor {
        .systemGreen
    }
}
