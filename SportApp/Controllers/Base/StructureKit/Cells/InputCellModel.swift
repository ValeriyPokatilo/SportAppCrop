import UIKit
import StructureKit
import RxSwift

final class InputCellModel: StructurableForTableView {

    var firstResponder: Observable<Bool?>?
    var showError: Observable<Bool>?
    var value: Observable<String?>?
    var placeholder: String?
    var returnKeyType: UIReturnKeyType = .default
    var returnKeyTapAction: EmptyBlock?
    var toolbar: UIToolbar?

    var valueChanged: ParameterBlock<String?>?

    init(toolbar: UIToolbar? = nil) {
        self.toolbar = toolbar
    }

    func configure(tableViewCell cell: InputCell) {
        cell.configure(with: self)
        cell.valueChanged = valueChanged
        cell.set(model: self)
    }

    func set(value: Observable<String?>?) -> Self {
        let state = self
        state.value = value
        return state
    }

    func set(firstResponder: Observable<Bool?>?) -> Self {
        let state = self
        state.firstResponder = firstResponder
        return state
    }

    func set(showError: Observable<Bool>?) -> Self {
        let state = self
        state.showError = showError
        return state
    }

    func set(valueChanged: ParameterBlock<String?>?) -> Self {
        let state = self
        state.valueChanged = valueChanged
        return state
    }

    func set(returnKeyType: UIReturnKeyType) -> Self {
        let state = self
        state.returnKeyType = returnKeyType
        return state
    }

    func set(returnKeyTapAction: EmptyBlock?) -> Self {
        let state = self
        state.returnKeyTapAction = returnKeyTapAction
        return state
    }
}
