import Foundation
import SnapKit
import RxSwift

final class ExtendedCell: UITableViewCell {

    private let mainStackView = UIStackView()
    private let borderView = UIView()
    private let headerStackView = UIStackView()
    private let titleLabel = UILabel()
    private let totalLabel = UILabel()
    private let iconView = UIImageView()
    private let plusButton = UIButton(type: .system)
    private let infoButton = UIButton(type: .system)

    private let currentStack = UIStackView()

    private var plusTapAction: EmptyBlock?
    private var showInfo: EmptyBlock?
    private var showSetView: ParameterBlock<SetEntity?>?

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

        headerStackView.axis = .horizontal
        headerStackView.spacing = 12
        headerStackView.alignment = .center

        totalLabel.textColor = .systemRed
        totalLabel.font = .systemFont(ofSize: 14, weight: .regular)

        titleLabel.textColor = .systemGreen
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true

        plusButton.setImage(.plusCircleImg, for: .normal)
        plusButton.tintColor = .systemGreen
        plusButton.addTarget(self, action: #selector(plusTap), for: .touchUpInside)
        plusButton.setImageSize(CGSize(width: 40, height: 40))

        infoButton.setImage(.infoImg, for: .normal)
        infoButton.tintColor = .darkGray
        infoButton.addTarget(self, action: #selector(infoTap), for: .touchUpInside)

        currentStack.axis = .vertical
        currentStack.spacing = 4

        mainStackView.setCustomSpacing(8, after: totalLabel)

        let infoTapGesture1 = UITapGestureRecognizer(target: self, action: #selector(infoTap))
        titleLabel.addGestureRecognizer(infoTapGesture1)
        titleLabel.isUserInteractionEnabled = true

        let infoTapGesture2 = UITapGestureRecognizer(target: self, action: #selector(infoTap))
        iconView.addGestureRecognizer(infoTapGesture2)
        iconView.isUserInteractionEnabled = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        iconView.layer.cornerRadius = 8

        titleLabel.text = nil
        totalLabel.text = nil

        plusTapAction = nil
        showSetView = nil

        currentStack.removeAllArrangedSubviews()
    }

    func configure(with model: ExtendedCellModel) {
        titleLabel.text = model.exercise.title ?? model.exercise.localizedTitle

        if let icon = UIImage(named: model.exercise.iconName ?? "") {
            iconView.image = icon
        } else {
            iconView.image = UIImage(named: "_defaultIcon")
        }

        iconView.layer.cornerRadius = 4
        iconView.clipsToBounds = true

        plusTapAction = model.plusTapAction
        showInfo = model.showInfo
        showSetView = model.showSetView

        buildSets(model.sets, archive: model.archive, unitType: model.exercise.unitType)

        addViews()
        configureLayout()

        if model.sets.isEmpty {
            totalLabel.removeFromSuperview()
        } else {
            totalLabel.text = String.makeTotalString(for: model.exercise, sets: model.sets)
            if mainStackView.arrangedSubviews.count >= 2 {
                mainStackView.insertArrangedSubview(totalLabel, at: 2)
            }
        }
    }

    private func addViews() {
        contentView.addSubview(borderView)
        borderView.addSubview(mainStackView)
        headerStackView.addArrangedSubview(iconView)
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(plusButton)
        mainStackView.addArrangedSubview(headerStackView)
        mainStackView.addArrangedSubview(currentStack)
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

        iconView.snp.makeConstraints { make in
            make.size.equalTo(54)
        }

        plusButton.snp.makeConstraints { make in
            make.size.equalTo(54)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
    }

    private func buildSets(_ sets: [SetEntity], archive: SetArchive, unitType: UnitType) {
        currentStack.removeAllArrangedSubviews()

        let count = max(sets.count, archive.sets.count)

        guard count > 0 else { return }

        for i in 0...count - 1 {
            if i < sets.count {
                let set = sets[i]
                let button = ExtendedRecordView(set: set, unitType: unitType, target: .current, isReal: true)
                currentStack.addArrangedSubview(button)
                button.showSetView = { [weak self] set in
                    self?.showSetView?(set)
                }
            } else {
                let set = archive.sets[i]
                let button = ExtendedRecordView(set: set, unitType: unitType, target: .current, isReal: false)
                currentStack.addArrangedSubview(button)
//                button.showSetView = { [weak self] _ in
//                    self?.showSetView?(set)
//                }
            }
        }
    }
}

extension ExtendedCell {
    @objc private func plusTap() {
        plusTapAction?()
    }

    @objc private func infoTap() {
        showInfo?()
    }
}

extension ExtendedCell {
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}
