import UIKit
import SnapKit

final class RecordEditController: UIViewController {

    private let containerView = UIView()
    private let mainStackView = UIStackView()
    private let titleLabel = UILabel()
    private let titleTextField = UITextField()
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    private let actionsStackView = UIStackView()

    private let record: RecordEntity?
    private let indicator: IndicatorEntity?
    private let indicatorsStorage = IndicatorsStorage.shared

    init(record: RecordEntity?, indicator: IndicatorEntity?) {
        self.record = record
        self.indicator = indicator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        configureLayout()
        configureAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }

    private func addViews() {
        view.addSubview(containerView)
        containerView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(titleTextField)
        mainStackView.addArrangedSubview(actionsStackView)
        if record != nil {
            mainStackView.addArrangedSubview(deleteButton)
        }
        actionsStackView.addArrangedSubview(cancelButton)
        actionsStackView.addArrangedSubview(saveButton)
    }

    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-100)
            make.width.equalToSuperview().inset(20)
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        titleTextField.snp.makeConstraints { make in
            make.width.equalTo(CGFloat.screenWidth / 3)
        }

        saveButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }

    private func configureAppearance() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        mainStackView.axis = .vertical
        mainStackView.spacing = 12

        titleLabel.text = indicator?.title ?? "newRecordStr".localized()
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .center

        titleTextField.autocorrectionType = .no
        titleTextField.borderStyle = .roundedRect
        titleTextField.font = .systemFont(ofSize: 28, weight: .bold)
        titleTextField.textAlignment = .center
        titleTextField.keyboardType = .decimalPad
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addSaveButton(titleTextField)

        if let value = record?.value {
            titleTextField.text = "\(value)"
        }

        containerView.backgroundColor = .baseLevelZero25
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        actionsStackView.axis = .horizontal
        actionsStackView.spacing = 8
        actionsStackView.distribution = .fillEqually

        saveButton.setTitle("saveStr".localized(), for: .normal)
        saveButton.backgroundColor = .baseLevelA
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8
        updateSaveButton(isEnabled: record != nil)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        cancelButton.setTitle("cancelStr".localized(), for: .normal)
        cancelButton.backgroundColor = .systemRed
        cancelButton.tintColor = .white
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        deleteButton.setTitle("deleteStr".localized(), for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    private func updateSaveButton(isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.backgroundColor = isEnabled ? .systemGreen : .baseLevelA
    }
}

extension RecordEditController {
    @objc private func saveTapped() {
        let valueText = titleTextField.text?.replacingOccurrences(of: ",", with: ".")

        guard let value = Double(valueText ?? "") else {
            return
        }

        if let record {
            indicatorsStorage.saveRecord(
                entity: record,
                indicator: indicator,
                value: value
            )
        } else {
            indicatorsStorage.saveRecord(
                entity: record,
                indicator: indicator,
                value: value
            )
            AnalyticsManager.shared.logUnitValueAdded()
        }

        dismiss(animated: true, completion: nil)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func deleteTapped() {
        dismiss(animated: true, completion: { [weak self] in
            guard let record = self?.record else {
                return
            }
            self?.indicatorsStorage.deleteRecord(record)
        })
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let isEnabled = !(textField.text?.isEmpty ?? true)
        updateSaveButton(isEnabled: isEnabled)
    }

    private func addSaveButton(_ textField: UITextField) {
        let keyboardToolBar = UIToolbar()
        textField.inputAccessoryView = keyboardToolBar
        keyboardToolBar.sizeToFit()

        let saveButton = UIBarButtonItem(title: "saveStr".localized(),
                                         style: .done,
                                         target: self,
                                         action: #selector(saveTapped))
        saveButton.tintColor = .systemGreen

        keyboardToolBar.items = [.flexBarButton, saveButton]
    }
}

extension RecordEditController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        if string.isEmpty {
            return true
        }

        if textField == titleTextField {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
            let characterSet = CharacterSet(charactersIn: string)

            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

            let commaCount = updatedText.components(separatedBy: ",").count - 1
            let dotCount = updatedText.components(separatedBy: ".").count - 1

            return allowedCharacters.isSuperset(of: characterSet) && commaCount <= 1 && dotCount <= 1
        }

        return true
    }
}
