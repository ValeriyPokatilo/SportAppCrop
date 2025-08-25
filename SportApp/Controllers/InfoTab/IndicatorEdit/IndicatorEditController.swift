import UIKit
import SnapKit

final class IndicatorEditController: UIViewController {

    private let containerView = UIView()
    private let mainStackView = UIStackView()
    private let titleLabel = UILabel()
    private let titleTextField = UITextField()
    private let segmentedControl = UISegmentedControl()
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    private let actionsStackView = UIStackView()

    private let unitArray: [String]
    private let indicator: IndicatorEntity?
    private let indicatorsStorage = IndicatorsStorage.shared

    init(indicator: IndicatorEntity?) {
        self.indicator = indicator
        self.unitArray = ConfStorage.shared.conf.defaultUnit.units
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
        mainStackView.addArrangedSubview(segmentedControl)
        mainStackView.addArrangedSubview(actionsStackView)
        if indicator != nil {
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

        titleLabel.text = indicator?.title ?? "newIndicatorStr".localized()
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .center

        titleTextField.text = indicator?.title
        titleTextField.borderStyle = .roundedRect
        titleTextField.autocorrectionType = .no
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        containerView.backgroundColor = .baseLevelZero25
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        for (index, unit) in unitArray.enumerated() {
            segmentedControl.insertSegment(withTitle: unit, at: index, animated: false)
        }

        if let unit = indicator?.unit, let index = unitArray.firstIndex(of: unit) {
            segmentedControl.selectedSegmentIndex = index
        } else {
            segmentedControl.selectedSegmentIndex = 0
        }

        actionsStackView.axis = .horizontal
        actionsStackView.spacing = 8
        actionsStackView.distribution = .fillEqually

        saveButton.setTitle("saveStr".localized(), for: .normal)
        saveButton.backgroundColor = .baseLevelA
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8
        updateSaveButton(isEnabled: indicator != nil)
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

extension IndicatorEditController {
    @objc private func saveTapped() {
        guard let title = titleTextField.text else {
            return
        }

        indicatorsStorage.saveIndicator(
            entity: indicator,
            title: title,
            unit: unitArray[segmentedControl.selectedSegmentIndex]
        )

        let conf = ConfStorage.shared.conf
        AnalyticsManager.shared.logUnitCreated(system: conf.defaultUnit.titleRu)

        dismiss(animated: true, completion: nil)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func deleteTapped() {
        dismiss(animated: true, completion: { [weak self] in
            guard let indicator = self?.indicator else {
                return
            }
            self?.indicatorsStorage.deleteIndicator(indicator)
        })
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let isEnabled = !(textField.text?.isEmpty ?? true)
        updateSaveButton(isEnabled: isEnabled)
    }
}
