import Foundation
import SnapKit
import RxSwift

final class SetsArviveCell: UITableViewCell {

    private let mainStackView = UIStackView()
    private let borderView = UIView()
    private let dateLabel = UILabel()
    private let totalLabel = UILabel()
    private let currentScroll = UIScrollView()
    private let currentStack = UIStackView()

    private var stackHeight = CGFloat(0)

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

        totalLabel.textColor = .baseLevelOne
        totalLabel.font = .systemFont(ofSize: 14, weight: .regular)

        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dateLabel.textAlignment = .left
        dateLabel.numberOfLines = 0
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        currentStack.axis = .horizontal
        currentStack.spacing = 8
    }

    func configure(with model: SetsArviveCellModel) {
        dateLabel.text = formattedDate(from: model.archive.date)

        switch model.exercise.unitType {
        case .withWeight, .distance:
            stackHeight = 58
        case .withoutWeight, .timer:
            stackHeight = 42
        }

        showSetView = model.showSetView

        buildSets(model.archive.sets, unitType: model.exercise.unitType)

        addViews()
        configureLayout()

        totalLabel.text = String.makeTotalString(for: model.exercise, sets: model.archive.sets)
    }

    private func addViews() {
        contentView.addSubview(borderView)
        borderView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(currentScroll)
        mainStackView.addArrangedSubview(totalLabel)
        currentScroll.addSubview(currentStack)
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

        currentScroll.snp.makeConstraints { make in
            make.height.equalTo(stackHeight)
        }

        currentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

extension SetsArviveCell {
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}
