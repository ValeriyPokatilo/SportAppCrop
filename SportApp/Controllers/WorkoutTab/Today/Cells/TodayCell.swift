import Foundation
import SnapKit
import RxSwift

final class TodayCell: UITableViewCell {

    private let mainStackView = UIStackView()
    private let borderView = UIView()
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let totalLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    private let previousButton = UIButton(type: .system)
    private let infoButton = UIButton(type: .system)
    private let currentScroll = UIScrollView()
    private let currentStack = UIStackView()

    private var stackHeight = CGFloat(0)

    private var plusTapAction: EmptyBlock?
    private var showPrevious: EmptyBlock?
    private var showInfo: EmptyBlock?
    private var showSetView: ParameterBlock<SetEntity>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        totalLabel.text = nil
        plusTapAction = nil
        showPrevious = nil
        showInfo = nil
        showSetView = nil

        previousButton.isEnabled = true
        previousButton.alpha = 1

        currentStack.removeAllArrangedSubviews()
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25

        mainStackView.axis = .vertical
        mainStackView.spacing = 4

        borderView.backgroundColor = .baseLevelZero
        borderView.layer.cornerRadius = 8
        borderView.layer.shadowColor = UIColor.black.cgColor
        borderView.layer.shadowOpacity = 0.2
        borderView.layer.shadowRadius = 4
        borderView.layer.shadowOffset = CGSize(width: 3, height: 3)
        borderView.layer.borderColor = UIColor.systemGreen.cgColor

        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        titleStackView.alignment = .center

        totalLabel.textColor = .systemRed
        totalLabel.font = .systemFont(ofSize: 14, weight: .regular)

        titleLabel.textColor = .systemGreen
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        plusButton.setImage(.plusCircleImg, for: .normal)
        plusButton.tintColor = .systemGreen
        plusButton.addTarget(self, action: #selector(plusTap), for: .touchUpInside)
        plusButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        plusButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        previousButton.setImage(.previousImg, for: .normal)
        previousButton.tintColor = .darkGray
        previousButton.addTarget(self, action: #selector(previousTap), for: .touchUpInside)
        previousButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        previousButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        infoButton.setImage(.infoImg, for: .normal)
        infoButton.tintColor = .darkGray
        infoButton.addTarget(self, action: #selector(infoTap), for: .touchUpInside)
        infoButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        infoButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        currentStack.axis = .horizontal
        currentStack.spacing = 8
    }

    func configure(with model: TodayCellModel) {
        titleLabel.text = model.exercise.title ?? model.exercise.localizedTitle

        switch model.exercise.unitType {
        case .withWeight, .distance:
            stackHeight = 72
        case .withoutWeight, .timer:
            stackHeight = 50
        }

        plusTapAction = model.plusTapAction
        showPrevious = model.showPrevious
        showInfo = model.showInfo
        showSetView = model.showSetView

        buildSets(model.sets, unitType: model.exercise.unitType)

        addViews()
        configureLayout()

        if model.archive.sets.isEmpty {
            previousButton.isEnabled = false
            previousButton.alpha = 0.5
        } else {
            previousButton.isEnabled = true
            previousButton.alpha = 1
        }

        if model.sets.isEmpty {
            totalLabel.removeFromSuperview()
        } else {
            totalLabel.text =  String.makeTotalString(for: model.exercise, sets: model.sets)
            if mainStackView.arrangedSubviews.count >= 2 {
                mainStackView.insertArrangedSubview(totalLabel, at: 2)
            }
        }
    }

    private func addViews() {
        contentView.addSubview(borderView)
        borderView.addSubview(mainStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(infoButton)
        titleStackView.addArrangedSubview(previousButton)
        titleStackView.addArrangedSubview(plusButton)
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(currentScroll)
        currentScroll.addSubview(currentStack)
    }

    private func configureLayout() {
        borderView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        mainStackView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        currentScroll.snp.remakeConstraints { make in
            make.height.equalTo(stackHeight)
        }

        previousButton.snp.remakeConstraints { make in
            make.width.equalTo(28)
            make.height.equalTo(24)
        }

        plusButton.snp.remakeConstraints { make in
            make.size.equalTo(24)
        }

        infoButton.snp.remakeConstraints { make in
            make.size.equalTo(24)
        }

        currentStack.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(stackHeight)
        }
    }

    private func buildSets(_ sets: [SetEntity], unitType: UnitType) {
        currentStack.removeAllArrangedSubviews()

        sets.forEach { set in
            let button = SetButton(set: set, unitType: unitType, target: .current)
            button.showSetView = { [weak self] set in
                self?.showSetView?(set)
            }
            currentStack.addArrangedSubview(button)
        }
    }
}

extension TodayCell {
    @objc private func plusTap() {
        plusTapAction?()
    }

    @objc private func previousTap() {
        showPrevious?()
    }

    @objc private func infoTap() {
        showInfo?()
    }
}
