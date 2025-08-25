import UIKit
import RxCocoa
import RxSwift

final class SetInputView: UIView {

    private let parent: SetAlertController
    private let exercise: ExerciseModel
    private let set: SetEntity?

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let mainStack = UIStackView()

    private let weightStack = UIStackView()
    private let weightDescription = UILabel()
    private let weightTextField = UITextField()

    private let repsStack = UIStackView()
    private let repsDescription = UILabel()
    private let repsTextField = UITextField()

    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)

    private let showTitleError = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()

    init(parent: SetAlertController, exercise: ExerciseModel, set: SetEntity?) {
        self.parent = parent
        self.exercise = exercise
        self.set = set
        super.init(frame: .zero)

        addViews()
        configureAppearance()
        configureLayout()
        configureDynamics()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(mainStack)
        containerView.addSubview(removeButton)
        mainStack.addArrangedSubview(weightStack)
        mainStack.addArrangedSubview(repsStack)
        weightStack.addArrangedSubview(weightTextField)
        weightStack.addArrangedSubview(weightDescription)
        weightStack.addArrangedSubview(cancelButton)
        repsStack.addArrangedSubview(repsTextField)
        repsStack.addArrangedSubview(repsDescription)
        repsStack.addArrangedSubview(saveButton)
        if !exercise.unitType.showWeight {
            cancelButton.removeFromSuperview()
            weightStack.removeFromSuperview()
            repsStack.addArrangedSubview(cancelButton)
        }
    }

    private func configureAppearance() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)

        if exercise.unitType.showWeight {
            weightTextField.becomeFirstResponder()
        } else if exercise.unitType == .withoutWeight {
            repsTextField.becomeFirstResponder()
        }

        if let set {
            weightTextField.text = String(set.weight)
            repsTextField.text = String(set.reps)
        }

        containerView.backgroundColor = .baseLevelZero25
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        titleLabel.numberOfLines = 0
        titleLabel.textColor = .baseLevelOne
        titleLabel.text = exercise.localizedTitle
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .center

        mainStack.axis = .horizontal
        mainStack.spacing = 16
        mainStack.distribution = .fillEqually

        weightStack.axis = .vertical
        weightStack.spacing = 8
        weightStack.alignment = .center

        repsStack.axis = .vertical
        repsStack.spacing = 8
        repsStack.alignment = .center

        weightDescription.text = exercise.unitType.descriptionWeight
        repsDescription.text = exercise.unitType.descriptionReps

        weightTextField.borderStyle = .roundedRect
        weightTextField.font = .systemFont(ofSize: 28, weight: .bold)
        weightTextField.textAlignment = .center
        weightTextField.keyboardType = .decimalPad
        weightTextField.clearButtonMode = .whileEditing
        weightTextField.delegate = self

        repsTextField.borderStyle = .roundedRect
        repsTextField.font = .systemFont(ofSize: 28, weight: .bold)
        repsTextField.textAlignment = .center
        repsTextField.keyboardType = .numberPad
        repsTextField.clearButtonMode = .whileEditing
        repsTextField.delegate = self
        repsTextField.addTarget(self, action: #selector(repsEditingChanged), for: .editingChanged)

        configureActions()
    }

    private func configureActions() {
        saveButton.setTitle("saveStr".localized(), for: .normal)
        saveButton.backgroundColor = .systemGreen
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8

        cancelButton.setTitle("cancelStr".localized(), for: .normal)
        cancelButton.backgroundColor = .systemRed
        cancelButton.tintColor = .white
        cancelButton.layer.cornerRadius = 8

        removeButton.setTitle("deleteStr".localized(), for: .normal)
        removeButton.setTitleColor(.systemRed, for: .normal)
        removeButton.alpha = set == nil ? 0 : 1

        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)

        addNextButton(weightTextField)
        addSaveButton(repsTextField)
    }

    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY).offset(-100)
            make.width.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        mainStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        removeButton.snp.makeConstraints { make in
            make.top.equalTo(mainStack.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(set == nil ? 0 : 38)
        }

        weightTextField.snp.makeConstraints { make in
            make.width.equalTo(CGFloat.screenWidth / 3)
        }

        repsTextField.snp.makeConstraints { make in
            make.width.equalTo(CGFloat.screenWidth / 3)
        }

        saveButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }

        cancelButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    private func configureDynamics() {
        showTitleError
            .subscribe(onNext: { [weak self] showError in
                if showError {
                    UIView.animate(withDuration: 0.3) {
                        self?.repsTextField.layer.borderColor = UIColor.systemRed.cgColor
                        self?.repsTextField.layer.borderWidth = 2
                        self?.repsTextField.layer.cornerRadius = 8
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self?.repsTextField.layer.borderColor = UIColor.clear.cgColor
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SetInputView {
    private func addNextButton(_ textField: UITextField) {
        let keyboardToolBar = UIToolbar()
        textField.inputAccessoryView = keyboardToolBar
        keyboardToolBar.sizeToFit()

        let nextButton = UIBarButtonItem(title: "nextStr".localized(),
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapNext))
        nextButton.tintColor = .systemGreen

        keyboardToolBar.items = [.flexBarButton, nextButton]
    }

    private func addSaveButton(_ textField: UITextField) {
        let keyboardToolBar = UIToolbar()
        textField.inputAccessoryView = keyboardToolBar
        keyboardToolBar.sizeToFit()

        let saveButton = UIBarButtonItem(title: "saveStr".localized(),
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapSave))
        saveButton.tintColor = .systemGreen

        keyboardToolBar.items = [.flexBarButton, saveButton]
    }
}

extension SetInputView {
    @objc private func cancelTapped() {
        parent.dismiss(animated: true, completion: nil)
    }

    @objc private func removeTapped() {
        parent.dismiss(animated: true, completion: { [weak self] in
            guard let set = self?.set else {
                return
            }
            CoreDataManager.shared.removeSet(set: set)
        })
    }

    @objc private func didTapNext() {
        weightTextField.resignFirstResponder()
        repsTextField.becomeFirstResponder()
    }

    @objc private func didTapSave() {
        saveTapped()
    }

    @objc private func saveTapped() {
        if repsTextField.text?.isEmpty == true {
            showTitleError.accept(true)
        } else {
            let weightText = weightTextField.text?.replacingOccurrences(of: ",", with: ".")
            AnalyticsManager.shared.logSetAdded(forExerciseTitle: exercise.titleRu ?? "custom")
            CoreDataManager.shared.saveSet(
                entity: set,
                model: SetModel(
                    id: UUID(),
                    exerciseId: exercise.id,
                    timeStamp: Date(),
                    weight: Double(weightText ?? "") ?? 0.0,
                    reps: Int(repsTextField.text ?? "") ?? 0
                ))
            parent.dismiss(animated: true, completion: nil)
        }
    }

    @objc private func repsEditingChanged() {
        showTitleError.accept(false)
    }
}

extension SetInputView: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        if string.isEmpty {
            return true
        }

        if textField == weightTextField {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
            let characterSet = CharacterSet(charactersIn: string)

            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

            let commaCount = updatedText.components(separatedBy: ",").count - 1
            let dotCount = updatedText.components(separatedBy: ".").count - 1

            return allowedCharacters.isSuperset(of: characterSet) && commaCount <= 1 && dotCount <= 1
        } else if textField == repsTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }

        return true
    }
}
