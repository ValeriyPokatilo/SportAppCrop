import UIKit
import SnapKit

final class DefaultUnitController: UIViewController {

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let segmentedControl = UISegmentedControl(
        items: MSystem.allCases.dropLast().map { $0.title }
    )
    private let saveButton = UIButton(type: .system)

    init() {
        super.init(nibName: nil, bundle: nil)
        addViews()
        configureLayout()
        configureAppearance()
        loadSavedSelection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(segmentedControl)
        containerView.addSubview(saveButton)
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

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
    }

    private func configureAppearance() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        titleLabel.text = "defUnitsTitleStr".localized()
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)

        saveButton.setTitle("saveStr".localized(), for: .normal)
        saveButton.backgroundColor = .baseLevelA
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveButton.isEnabled = false

        containerView.backgroundColor = .baseLevelZero25
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        segmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }

    private func loadSavedSelection() {
        let savedSystem = ConfStorage.shared.conf.defaultUnit
        if let index = MSystem.allCases.dropLast().firstIndex(of: savedSystem) {
            segmentedControl.selectedSegmentIndex = index
            saveButton.isEnabled = true
            saveButton.backgroundColor = .systemGreen
        }
    }

    @objc private func saveTapped() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        let allSystems = MSystem.allCases.dropLast()
        if selectedIndex >= 0, selectedIndex < allSystems.count {
            let selectedOption = allSystems[selectedIndex]
            var conf = ConfStorage.shared.conf
            conf.defaultUnit = selectedOption
            ConfStorage.shared.updateConfiguration(conf)
        }

        dismiss(animated: true, completion: nil)
    }

    @objc private func segmentValueChanged() {
        saveButton.isEnabled = true
        saveButton.backgroundColor = .systemGreen
    }
}
