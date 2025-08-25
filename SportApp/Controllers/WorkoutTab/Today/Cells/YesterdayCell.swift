import Foundation
import SnapKit
import RxSwift

final class YesterdayCell: UITableViewCell {

    private let mainStackView = UIStackView()
    private let borderView = UIView()
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let totalLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    private let previousButton = UIButton(type: .system)
    private let infoButton = UIButton(type: .system)
    private let dateLabel = UILabel()
    private let previousTotalLabel = UILabel()
    private let previousBackground = UIView()

    private let currentScroll = UIScrollView()
    private let currentStack = UIStackView()
    private let previousScroll = UIScrollView()
    private let previousStack = UIStackView()

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
        previousStack.axis = .horizontal
        previousStack.spacing = 8

        previousBackground.backgroundColor = .baseLevelOne.withAlphaComponent(0.08)
        previousBackground.layer.cornerRadius = 8
        previousBackground.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        dateLabel.font = .systemFont(ofSize: 14, weight: .bold)
        previousTotalLabel.font = .systemFont(ofSize: 14)

        mainStackView.setCustomSpacing(8, after: totalLabel)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        totalLabel.text = nil
        previousTotalLabel.text = nil
        dateLabel.text = nil

        plusTapAction = nil
        showPrevious = nil
        showSetView = nil

        previousButton.isEnabled = true
        previousButton.alpha = 1.0

        currentStack.removeAllArrangedSubviews()
        previousStack.removeAllArrangedSubviews()
    }

    func configure(with model: YesterdayCellModel) {
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

        dateLabel.text = "\("lastWorkoutStr".localized()) \(formattedDate(from: model.archive.date))"

        buildSets(model.sets, archive: model.archive, unitType: model.exercise.unitType)

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
            totalLabel.text = String.makeTotalString(for: model.exercise, sets: model.sets)
            if mainStackView.arrangedSubviews.count >= 2 {
                mainStackView.insertArrangedSubview(totalLabel, at: 2)
            }
        }

        previousTotalLabel.text = String.makeTotalString(for: model.exercise, sets: model.archive.sets)
    }

    private func addViews() {
        contentView.addSubview(borderView)
        borderView.addSubview(previousBackground)
        borderView.addSubview(mainStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(infoButton)
        titleStackView.addArrangedSubview(previousButton)
        titleStackView.addArrangedSubview(plusButton)
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(currentScroll)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(previousScroll)
        mainStackView.addArrangedSubview(previousTotalLabel)
        currentScroll.addSubview(currentStack)
        previousScroll.addSubview(previousStack)
    }

    private func configureLayout() {
        borderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        previousButton.snp.makeConstraints { make in
            make.width.equalTo(28)
            make.height.equalTo(24)
        }

        plusButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }

        previousBackground.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.top).offset(-4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        currentScroll.snp.remakeConstraints { make in
            make.height.equalTo(stackHeight)
        }

        previousScroll.snp.remakeConstraints { make in
            make.height.equalTo(stackHeight)
        }

        currentStack.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        previousStack.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

    private func buildSets(_ sets: [SetEntity], archive: SetArchive, unitType: UnitType) {
        currentStack.removeAllArrangedSubviews()

        sets.forEach { set in
            let button = SetButton(set: set, unitType: unitType, target: .current)
            button.showSetView = { [weak self] set in
                self?.showSetView?(set)
            }
            currentStack.addArrangedSubview(button)
        }

        previousStack.removeAllArrangedSubviews()

        archive.sets.forEach { set in
            let button = SetButton(set: set, unitType: unitType, target: .previous)
            button.showSetView = { [weak self] set in
                self?.showSetView?(set)
            }
            previousStack.addArrangedSubview(button)
        }
    }
}

extension YesterdayCell {
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

extension YesterdayCell {
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}
