import Foundation
import SnapKit
import RxSwift

final class IndicatorCell: UITableViewCell {

    private let borderView = UIView()
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let mStackView = UIStackView()
    private let plusButton = UIButton(type: .system)
    private let editButton = UIButton(type: .system)
    private let moreButton = UIButton(type: .system)

    var recordEdit: DoubleParametersBlock<RecordEntity?, IndicatorEntity?>?

    private var plusTapAction: EmptyBlock?
    private var editTapAction: EmptyBlock?
    private var moreAction: EmptyBlock?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleStackView.removeAllArrangedSubviews()
        mStackView.removeAllArrangedSubviews()
        titleLabel.text = nil
        plusTapAction = nil
        editTapAction = nil
        recordEdit = nil
        plusButton.tintColor = .systemGreen
        plusButton.isEnabled = true
    }

    func configure(with model: IndicatorCellModel) {
        if let title = model.indicator.title, let unit = model.indicator.unit {
            titleLabel.text = "\(title) (\(unit))"
        }

        plusTapAction = model.plusTapAction
        editTapAction = model.editTapAction
        recordEdit = model.recordEdit
        moreAction = model.moreAction

        addViews(indicator: model.indicator)
        configureAppearance()
        configureLayout(recordCount: model.indicator.records?.count ?? 0)
    }

    private func addViews(indicator: IndicatorEntity) {
        contentView.addSubview(borderView)
        borderView.addSubview(titleStackView)
        borderView.addSubview(mStackView)
        borderView.addSubview(moreButton)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(editButton)
        titleStackView.addArrangedSubview(plusButton)

        guard let records = indicator.records as? Set<RecordEntity> else {
            return
        }

        for (index, record) in records
            .sorted(by: { $0.timestamp ?? Date() > $1.timestamp ?? Date() })
            .prefix(3)
            .enumerated() {
            let view = RecordView(record: record, indicator: indicator, clearBack: index % 2 == 1)

            if let timestamp = record.timestamp, Calendar.current.isDateInToday(timestamp) {
                plusButton.tintColor = .gray
                plusButton.isEnabled = false
            }

            view.recordEdit = { [weak self] record, indicator in
                self?.recordEdit?(record, indicator)
            }

            mStackView.addArrangedSubview(view)
        }
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25

        mStackView.axis = .vertical
        mStackView.spacing = 4

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

        editButton.setImage(.editCircleImg, for: .normal)
        editButton.tintColor = .darkGray
        editButton.addTarget(self, action: #selector(editTap), for: .touchUpInside)
        editButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        editButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        moreButton.setTitleColor(.systemGreen, for: .normal)
        moreButton.setTitle("moreStr".localized(), for: .normal)
        moreButton.titleLabel?.textAlignment = .right
        moreButton.addTarget(self, action: #selector(moreTap), for: .touchUpInside)
    }

    private func configureLayout(recordCount: Int) {
        borderView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        titleStackView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        if recordCount > 3 {
            mStackView.snp.remakeConstraints { make in
                make.top.equalTo(titleStackView.snp.bottom).offset(8)
                make.leading.equalToSuperview().offset(8)
                make.trailing.equalToSuperview().offset(-8)
            }

            moreButton.snp.remakeConstraints { make in
                make.top.equalTo(mStackView.snp.bottom).offset(8)
                make.leading.equalToSuperview().offset(8)
                make.trailing.equalToSuperview().offset(-8)
                make.bottom.equalToSuperview().offset(-8)
            }
        } else {
            mStackView.snp.remakeConstraints { make in
                make.top.equalTo(titleStackView.snp.bottom).offset(8)
                make.leading.equalToSuperview().offset(8)
                make.trailing.equalToSuperview().offset(-8)
                make.bottom.equalToSuperview().offset(-8)
            }

            moreButton.removeFromSuperview()
        }

        plusButton.snp.remakeConstraints { make in
            make.size.equalTo(24)
        }
    }
}

extension IndicatorCell {
    @objc private func plusTap() {
        plusTapAction?()
    }

    @objc private func editTap() {
        editTapAction?()
    }

    @objc private func moreTap() {
        moreAction?()
    }
}
