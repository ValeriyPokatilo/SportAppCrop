import UIKit

final class ExtendedRecordView: UIButton {

    var showSetView: ParameterBlock<SetEntity>?

    private var sideOffset: CGFloat = 8
    private var rowHeight: CGFloat = 18
    private var vOffset: CGFloat = 4

    private let borderView = UIView()
    private let weightLabel = UILabel()
    private let repsLabel = UILabel()
    private let dateLabel = UILabel()

    private let set: SetEntity
    private let unitType: UnitType
    private let target: SetTarget
    private let isReal: Bool

    private var borderColor: UIColor {
        switch isReal {
        case true:
            .systemGreen.withAlphaComponent(0.1)
        case false:
            .lightGray.withAlphaComponent(0.07)
        }
    }

    init(set: SetEntity, unitType: UnitType, target: SetTarget, isReal: Bool) {
        self.set = set
        self.unitType = unitType
        self.target = target
        self.isReal = isReal
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
        borderView.addSubview(weightLabel)
        borderView.addSubview(repsLabel)
        borderView.addSubview(dateLabel)
    }

    private func configureLayout() {
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        switch unitType {
        case .withWeight, .distance:
            repsLabel.textAlignment = .center
            weightLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(vOffset)
                make.bottom.equalToSuperview().offset(-vOffset)
                make.leading.equalToSuperview().offset(sideOffset)
                make.height.equalTo(rowHeight)
                make.width.equalTo(70)
            }

            repsLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(vOffset)
                make.bottom.equalToSuperview().offset(-vOffset)
                make.leading.equalTo(weightLabel.snp.trailing).offset(8)
                make.trailing.equalTo(dateLabel.snp.leading).offset(8)
                make.height.equalTo(rowHeight)
            }

            dateLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(vOffset)
                make.bottom.equalToSuperview().offset(-vOffset)
                make.trailing.equalToSuperview().offset(-sideOffset)
                make.width.equalTo(65)
                make.height.equalTo(rowHeight)
            }
        case .withoutWeight, .timer:
            repsLabel.textAlignment = .left
            repsLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(vOffset)
                make.bottom.equalToSuperview().offset(-vOffset)
                make.leading.equalToSuperview().offset(sideOffset)
                make.trailing.equalTo(dateLabel.snp.leading).offset(8)
                make.height.equalTo(rowHeight)
           }

            dateLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(vOffset)
                make.bottom.equalToSuperview().offset(-vOffset)
                make.trailing.equalToSuperview().offset(-sideOffset)
                make.width.equalTo(65)
                make.height.equalTo(rowHeight)
            }
        }
    }

    private func configureAppearance() {
        borderView.layer.cornerRadius = 5
        borderView.backgroundColor = borderColor

        weightLabel.textAlignment = .left
        weightLabel.alpha = isReal ? 1 : 0.18
        weightLabel.attributedText = configureString(
            value: Double(set.weight),
            unit: unitType.descriptionWeight
        )

        repsLabel.alpha = isReal ? 1 : 0.18
        repsLabel.attributedText = configureString(
            value: Int(set.reps),
            unit: unitType.descriptionReps
        )

        dateLabel.text = isReal ?
        configureTime(from: set.timeStamp ?? Date()) :
        configureShortDate(from: set.timeStamp ?? Date())

        dateLabel.font = .systemFont(ofSize: 11)
        dateLabel.textColor = .accentBlueBright
        dateLabel.textColor =  isReal ? .accentBlueBright : .darkGray
        dateLabel.textAlignment = .right
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

    private func configureShortDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}
