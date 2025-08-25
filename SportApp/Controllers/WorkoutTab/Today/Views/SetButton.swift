import UIKit

final class SetButton: UIButton {

    var showSetView: ParameterBlock<SetEntity>?

    private var sideOffset: CGFloat = 4

    private let borderView = UIView()
    private let valueLabel = UILabel()
    private let unitLabel = UILabel()
    private let dateLabel = UILabel()

    private let set: SetEntity
    private let unitType: UnitType
    private let target: SetTarget

    private var borderColor: UIColor {
        switch target {
        case .current:
            .systemGreen.withAlphaComponent(0.1)
        case .previous:
            .baseLevelZero50
        }
    }

    init(set: SetEntity, unitType: UnitType, target: SetTarget) {
        self.set = set
        self.unitType = unitType
        self.target = target
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
        showSetView?(set)
    }

    private func addViews() {
        addSubview(borderView)
        borderView.addSubview(valueLabel)
        borderView.addSubview(unitLabel)
        borderView.addSubview(dateLabel)
    }

    private func configureLayout() {
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        switch unitType {
        case .withWeight, .distance:
            valueLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(4)
                make.leading.equalToSuperview().offset(sideOffset)
                make.trailing.equalToSuperview().offset(-sideOffset)
            }

            unitLabel.snp.makeConstraints { make in
                make.top.equalTo(valueLabel.snp.bottom).offset(4)
                make.leading.equalToSuperview().offset(sideOffset)
                make.trailing.equalToSuperview().offset(-sideOffset)
            }

            dateLabel.snp.makeConstraints { make in
                make.top.equalTo(unitLabel.snp.bottom).offset(4)
                make.bottom.equalToSuperview().offset(-4)
                make.leading.equalToSuperview().offset(sideOffset)
                make.trailing.equalToSuperview().offset(-sideOffset)
            }
        case .withoutWeight, .timer:
            unitLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(4)
                make.leading.equalToSuperview().offset(sideOffset)
                make.trailing.equalToSuperview().offset(-sideOffset)
            }

            dateLabel.snp.makeConstraints { make in
                make.top.equalTo(unitLabel.snp.bottom).offset(4)
                make.bottom.equalToSuperview().offset(-4)
                make.leading.equalToSuperview().offset(sideOffset)
                make.trailing.equalToSuperview().offset(-sideOffset)
            }
        }
    }

    private func configureAppearance() {
        borderView.layer.cornerRadius = 5
        borderView.backgroundColor = borderColor

        valueLabel.attributedText = configureString(
            value: Double(set.weight),
            unit: unitType.descriptionWeight
        )

        unitLabel.attributedText = configureString(
            value: Int(set.reps),
            unit: unitType.descriptionReps
        )

        dateLabel.text = configureTime(from: set.timeStamp ?? Date())
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .accentBlueBright
    }

    private func configureString<T>(value: T, unit: String) -> NSAttributedString {
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold)
        ]

        let unitAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]

        let attributedString = NSMutableAttributedString(
            string: "\(value)",
            attributes: valueAttributes
        )

        attributedString.append(NSAttributedString(
            string: " \(unit)",
            attributes: unitAttributes
        ))

        return attributedString
    }

    private func configureTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
