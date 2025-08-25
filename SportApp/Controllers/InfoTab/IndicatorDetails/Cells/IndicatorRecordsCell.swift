import Foundation
import SnapKit
import RxSwift

final class IndicatorRecordsCell: UITableViewCell {

    private let mStackView = UIStackView()

    var recordEdit: DoubleParametersBlock<RecordEntity?, IndicatorEntity?>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mStackView.removeAllArrangedSubviews()
        recordEdit = nil
    }

    func configure(with model: IndicatorRecordsCellModel) {
        recordEdit = model.recordEdit

        addViews(indicator: model.indicator)
        configureAppearance()
        configureLayout()
    }

    private func addViews(indicator: IndicatorEntity) {
        contentView.addSubview(mStackView)

        guard let records = indicator.records as? Set<RecordEntity> else {
            return
        }

        for (index, record) in records
            .sorted(by: { $0.timestamp ?? Date() > $1.timestamp ?? Date() })
            .enumerated() {
            let view = RecordView(record: record, indicator: indicator, clearBack: index % 2 == 1)

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
    }

    private func configureLayout() {
        mStackView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
