import UIKit
import RxCocoa
import RxSwift

final class ExtendedSetController: UIViewController {

    private let exercise: ExerciseModel
    private let set: SetEntity?
    private let isReal: Bool
    private let plan: SetPlan?

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let mainStack = UIStackView()

    private let weightStack = UIStackView()
    private let weightDescription = UILabel()
    private let weightPicker = UIPickerView()

    private let repsStack = UIStackView()
    private let repsDescription = UILabel()
    private let repsPicker = UIPickerView()

    private let dotLabel = UILabel()

    private let buttonsStack = UIStackView()

    private let intValues = Array(0...499)
    private let floatValues: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)

    private let showTitleError = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()

    init(exercise: ExerciseModel, set: SetEntity?, isReal: Bool, plan: SetPlan?) {
        self.exercise = exercise
        self.set = set
        self.isReal = isReal
        self.plan = plan
        super.init(nibName: nil, bundle: nil)

        addViews()
        configureAppearance()
        configureLayout()
        configureDynamics()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        view.addSubview(containerView)
        containerView.addSubview(cancelButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(mainStack)
        containerView.addSubview(buttonsStack)
        containerView.addSubview(removeButton)

        if exercise.unitType.showWeight {
            mainStack.addArrangedSubview(weightStack)
            containerView.addSubview(dotLabel)
        }
        mainStack.addArrangedSubview(repsStack)

        weightStack.addArrangedSubview(weightPicker)
        weightStack.addArrangedSubview(weightDescription)

        repsStack.addArrangedSubview(repsPicker)
        repsStack.addArrangedSubview(repsDescription)

        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(saveButton)
    }

    private func configureAppearance() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        containerView.backgroundColor = .baseLevelZero25
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        titleLabel.numberOfLines = 0
        titleLabel.textColor = .baseLevelOne
        titleLabel.text = exercise.localizedTitle
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .center

        mainStack.axis = .horizontal
        mainStack.spacing = 4
        mainStack.distribution = .fillProportionally

        weightStack.axis = .vertical
        weightStack.spacing = 8
        weightStack.alignment = .center

        repsStack.axis = .vertical
        repsStack.spacing = 8
        repsStack.alignment = .center

        weightDescription.text = exercise.unitType.descriptionWeight
        repsDescription.text = exercise.unitType.descriptionReps

        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 8
        buttonsStack.distribution = .fillEqually

        dotLabel.text = ","

        weightPicker.delegate = self
        repsPicker.delegate = self

        let weight = abs(set?.weight ?? plan?.weight ?? 0)
        let initialIntWeight = Int(weight)
        let initialFloatWeight = Int((weight - Double(initialIntWeight)) * 10)
        let initialReps = set?.reps ?? Int64(plan?.reps ?? 0)

        if let weightIntIndex = intValues.firstIndex(of: Int(initialIntWeight)) {
            weightPicker.selectRow(weightIntIndex, inComponent: 0, animated: false)
        }
        if let weightFloatIndex = intValues.firstIndex(of: Int(initialFloatWeight)) {
            weightPicker.selectRow(weightFloatIndex, inComponent: 1, animated: false)
        }
        if let repsIndex = intValues.firstIndex(of: Int(initialReps)) {
            repsPicker.selectRow(repsIndex, inComponent: 0, animated: false)
        }

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
    }

    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        mainStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }

        buttonsStack.snp.makeConstraints { make in
            make.top.equalTo(mainStack.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        removeButton.snp.makeConstraints { make in
            make.top.equalTo(buttonsStack.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(set == nil ? 0 : 38)
        }

        if exercise.unitType.showWeight {
            dotLabel.snp.makeConstraints { make in
                make.centerX.equalTo(weightPicker.snp.centerX)
                make.centerY.equalTo(weightPicker.snp.centerY)
            }
        }

        saveButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }

    private func configureDynamics() {
        showTitleError
            .subscribe(onNext: { [weak self] showError in
                if showError {
                    UIView.animate(withDuration: 0.3) {
                        self?.repsPicker.layer.borderColor = UIColor.systemRed.cgColor
                        self?.repsPicker.layer.borderWidth = 2
                        self?.repsPicker.layer.cornerRadius = 8
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self?.repsPicker.layer.borderColor = UIColor.clear.cgColor
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ExtendedSetController {
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func removeTapped() {
        dismiss(animated: true, completion: { [weak self] in
            guard let set = self?.set else {
                return
            }
            CoreDataManager.shared.removeSet(set: set)
        })
    }

    @objc private func didTapNext() {
        weightPicker.resignFirstResponder()
        repsPicker.becomeFirstResponder()
    }

    @objc private func didTapSave() {
        saveTapped()
    }

    @objc private func saveTapped() {
        let weight1 = intValues[weightPicker.selectedRow(inComponent: 0)]
        let weight2 = floatValues[weightPicker.selectedRow(inComponent: 1)]
        let weight: Double = Double(weight1) + Double(weight2) * 0.1
        let reps: Int = intValues[repsPicker.selectedRow(inComponent: 0)]

        CoreDataManager.shared.saveSet(
            entity: isReal ? set: nil,
            model: SetModel(
                id: UUID(), // ***
                exerciseId: exercise.id,
                timeStamp: Date(),
                weight: weight,
                reps: reps
            ))

        AnalyticsManager.shared.logSetAdded(forExerciseTitle: exercise.titleRu ?? "custom")

        dismiss(animated: true, completion: nil)
    }

    @objc private func repsEditingChanged() {
        showTitleError.accept(false)
    }
}

extension ExtendedSetController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case weightPicker:
            2
        case repsPicker:
            1
        default:
            0
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case weightPicker:
            component == 0 ? intValues.count : floatValues.count
        case repsPicker:
            intValues.count
        default:
            0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case weightPicker:
            component == 0 ? "\(intValues[row])" : "\(floatValues[row])"
        case repsPicker:
            "\(intValues[row])"
        default:
            "-"
        }
    }
}

extension ExtendedSetController: UIPickerViewDelegate {

}
