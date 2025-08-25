import UIKit

extension UIView {
    class var xibName: String {
        typeName(of: self)
    }
}

public func typeName<T>(of type: T.Type) -> String {
    String(describing: type)
}
