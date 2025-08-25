import Foundation
import RxCocoa
import StructureKit

protocol StructurKitViewModelAbstract {
    var title: BehaviorRelay<String?> { get }

    var backgroundColor: UIColor { get }

    var sections: BehaviorRelay<[StructureSection]> { get }

    var movableCells: [UITableViewCell.Type] { get }

    var registerClasses: [UITableViewCell.Type] { get }

    var headerFooterTypes: [UIView.Type] { get }

    var leftBarButtonItem: UIBarButtonItem? { get }

    var rightBarButtonItem: UIBarButtonItem? { get }

    var separatorStyle: UITableViewCell.SeparatorStyle { get }

    var tableSetEditing: BehaviorRelay<Bool> { get }

    var placeholderView: BehaviorRelay<UIView?> { get }

    var showAlert: BehaviorRelay<AlertConfiguration?> { get }

    func moveRows(from: Int, to: Int)
}

extension StructurKitViewModelAbstract {

    var title: BehaviorRelay<String?> {
        BehaviorRelay(value: "")
    }

    var backgroundColor: UIColor {
        .baseLevelZero25
    }
    var movableCells: [UITableViewCell.Type] {
        []
    }

    var registerClasses: [UITableViewCell.Type] {
        []
    }

    var headerFooterTypes: [UIView.Type] {
        []
    }

    var leftBarButtonItem: UIBarButtonItem? {
        nil
    }

    var rightBarButtonItem: UIBarButtonItem? {
        nil
    }

    var separatorStyle: UITableViewCell.SeparatorStyle {
        .none
    }

    var tableSetEditing: BehaviorRelay<Bool> {
        BehaviorRelay(value: false)
    }

    var placeholderView: BehaviorRelay<UIView?> {
        BehaviorRelay(value: nil)
    }

    var showAlert: BehaviorRelay<AlertConfiguration?> {
        BehaviorRelay(value: nil)
    }

    func moveRows(from: Int, to: Int) {}
}
