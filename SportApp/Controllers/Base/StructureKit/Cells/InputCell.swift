import UIKit
import RxSwift

final class InputCell: UITableViewCell {

    private let inputTextField = UITextField()
    private let disposeBag = DisposeBag()
    private var returnKeyTapAction: EmptyBlock?

    var valueChanged: ParameterBlock<String?>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: InputCellModel) {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25

        inputTextField.placeholder = model.placeholder
        inputTextField.borderStyle = .roundedRect
        inputTextField.autocorrectionType = .no
        inputTextField.clearButtonMode = .whileEditing

        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        inputTextField.addTarget(self, action: #selector(returnKeyTapped), for: .editingDidEndOnExit)

        if let toolbar = model.toolbar {
            inputTextField.inputAccessoryView = toolbar
        }
    }

    func set(value: Observable<String?>?) {
        value?
            .subscribe(onNext: { [weak self] text in
                self?.set(text: text)
            })
            .disposed(by: disposeBag)
    }

    func set(firstResponder: Observable<Bool?>?) {
        firstResponder?
            .subscribe(onNext: { [weak self] isFirstResponder in
                if isFirstResponder ?? false {
                    self?.inputTextField.becomeFirstResponder()
                } else {
                    self?.inputTextField.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }

    func set(showError: Observable<Bool>?) {
        showError?
            .subscribe(onNext: { [weak self] showError in
                if showError {
                    UIView.animate(withDuration: 0.3) {
                        self?.inputTextField.layer.borderColor = UIColor.systemRed.cgColor
                        self?.inputTextField.layer.borderWidth = 2
                        self?.inputTextField.layer.cornerRadius = 8
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self?.inputTextField.layer.borderColor = UIColor.clear.cgColor
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func set(returnKeyType: UIReturnKeyType) {
        inputTextField.returnKeyType = returnKeyType
    }

    func set(returnKeyTapAction: EmptyBlock?) {
        self.returnKeyTapAction = returnKeyTapAction
    }

    func set(model: InputCellModel) {
        set(value: model.value)
        set(firstResponder: model.firstResponder)
        set(showError: model.showError)
        set(returnKeyType: model.returnKeyType)
        set(returnKeyTapAction: model.returnKeyTapAction)
    }

    func set(text: String?) {
        inputTextField.text = text
    }

    private func addViews() {
        contentView.addSubview(inputTextField)
    }

    private func configureLayout() {
        inputTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        valueChanged?(textField.text ?? "")
    }

    @objc private func returnKeyTapped() {
        returnKeyTapAction?()
    }
}
