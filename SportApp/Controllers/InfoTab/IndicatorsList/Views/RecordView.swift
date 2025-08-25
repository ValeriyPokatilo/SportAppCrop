import UIKit

final class RecordView: UIButton {

    private let borderView = UIView()
    private let title = UILabel()
    private let value = UILabel()

    private let record: RecordEntity
    private let indicator: IndicatorEntity
    private let clearBack: Bool

    var recordEdit: DoubleParametersBlock<RecordEntity?, IndicatorEntity?>?

    init(record: RecordEntity, indicator: IndicatorEntity, clearBack: Bool) {
        self.record = record
        self.indicator = indicator
        self.clearBack = clearBack
        super.init(frame: .zero)

        addViews()
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        recordEdit?(record, indicator)
    }

    private func addViews() {
        addSubview(borderView)
        borderView.addSubview(title)
        borderView.addSubview(value)
    }

    private func configureLayout() {
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalToSuperview().offset(8)
        }

        value.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalTo(title.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-8)
        }
    }

    private func configureAppearance() {
        borderView.layer.cornerRadius = 5
        borderView.backgroundColor = clearBack ? .clear : .systemGreen.withAlphaComponent(0.1)

        let dateString = configureTime(from: record.timestamp ?? Date())
        title.text = "\("dotStr".localized()) \(dateString)"
        title.font = .systemFont(ofSize: 14)
        title.textAlignment = .left
        title.numberOfLines = 1

        value.text = "\(record.value) \(indicator.unit ?? "")"
        value.font = .systemFont(ofSize: 14)
        value.textAlignment = .right
        value.numberOfLines = 1
    }

    private func configureTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}
