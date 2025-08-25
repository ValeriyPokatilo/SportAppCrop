import UIKit

extension UITableView {
    func registerClasses(with types: [UITableViewCell.Type]) {
        for cellType in types {
            let identifier = String(describing: cellType)
            register(cellType, forCellReuseIdentifier: identifier)
        }
    }

    func registerHeaderFooter(with types: [UIView.Type]) {
        for itemType in types {
            let identifier = itemType.xibName
            if Bundle.main.path(forResource: identifier, ofType: "nib") != nil {
                let nib = UINib(nibName: itemType.xibName, bundle: nil)
                register(nib, forHeaderFooterViewReuseIdentifier: identifier)
            } else {
                register(itemType, forHeaderFooterViewReuseIdentifier: identifier)
            }
        }
    }
}
