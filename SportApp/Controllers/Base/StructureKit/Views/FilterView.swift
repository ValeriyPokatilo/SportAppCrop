import UIKit
import RxSwift

final class FilterView: UIView {

    private let stackView = UIStackView(frame: .zero)
    private let equipmentButton = UIButton(type: .system)
    private let muscleButton = UIButton(type: .system)
    private let unitTypeButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)
    private let separator = UIView(frame: .zero)

    var equipmentTap: EmptyBlock?
    var muscleTap: EmptyBlock?
    var unitTypeTap: EmptyBlock?
    var clearTap: EmptyBlock?

    init() {
        super.init(frame: .zero)
        addViews()
        configureAppearance()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ExerciseFilter) {
        equipmentButton.setTitle(model.equipment?.enumTitle ?? Equipment.allTitle, for: .normal)
        muscleButton.setTitle(model.muscle?.enumTitle ?? MuscleGroup.allTitle, for: .normal)
        unitTypeButton.setTitle(model.unitType?.enumTitle ?? UnitType.allTitle, for: .normal)

        if model.isChanged {
            stackView.addArrangedSubview(clearButton)
        } else {
            if stackView.arrangedSubviews.contains(clearButton) {
                clearButton.removeFromSuperview()
            }
        }
    }

    private func addViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(equipmentButton)
        stackView.addArrangedSubview(muscleButton)
        stackView.addArrangedSubview(unitTypeButton)
        addSubview(separator)
    }

    private func configureAppearance() {
        backgroundColor = .baseLevelZero25
        tintColor = .baseLevelZero25

        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally

        equipmentButton.setTitleColor(.white, for: .normal)
        equipmentButton.backgroundColor = .systemGreen
        equipmentButton.layer.cornerRadius = 8
        equipmentButton.titleLabel?.font = .systemFont(ofSize: 13)
        equipmentButton.addTarget(
            self,
            action: #selector(allEquipmentsTapped),
            for: .touchUpInside
        )

        muscleButton.setTitleColor(.white, for: .normal)
        muscleButton.backgroundColor = .systemGreen
        muscleButton.layer.cornerRadius = 8
        muscleButton.titleLabel?.font = .systemFont(ofSize: 13)
        muscleButton.addTarget(
            self,
            action: #selector(allMusclesTapped),
            for: .touchUpInside
        )

        unitTypeButton.setTitleColor(.white, for: .normal)
        unitTypeButton.backgroundColor = .systemGreen
        unitTypeButton.layer.cornerRadius = 8
        unitTypeButton.titleLabel?.font = .systemFont(ofSize: 13)
        unitTypeButton.addTarget(
            self,
            action: #selector(allUnitTypeTapped),
            for: .touchUpInside
        )

        clearButton.setImage(.clearCircleImg, for: .normal)
        clearButton.tintColor = .systemRed
        clearButton.addTarget(
            self,
            action: #selector(clearTapped),
            for: .touchUpInside
        )
        
        separator.backgroundColor = .systemGray
    }

    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints { make in
            make.size.equalTo(25)
        }
    }

    @objc private func allEquipmentsTapped() {
        equipmentTap?()
    }

    @objc private func allMusclesTapped() {
        muscleTap?()
    }

    @objc private func allUnitTypeTapped() {
        unitTypeTap?()
    }

    @objc private func clearTapped() {
        clearTap?()
    }
}
