import Foundation
import SnapKit
import SwipeCellKit

final class ExerciseResultCell: SwipeTableViewCell {

    private let iconImageView = UIImageView()
    private let shadowContainerView = UIView()

    private let titleLabel = UILabel()
    private let todayLabel = UILabel()
    private let previousLabel = UILabel()

    private let resultLabel = UILabel()
    private let resultContainer = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ExerciseResultCellModel) {
        backgroundColor = .baseLevelZero25
        selectionStyle = .none

        if let icon = UIImage(named: model.exercise.iconName ?? "") {
            iconImageView.image = icon
        } else {
            iconImageView.image = UIImage(named: "_defaultIcon")
        }
        iconImageView.layer.cornerRadius = 8
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.darkGray.cgColor
        iconImageView.clipsToBounds = true

        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.2
        shadowContainerView.layer.shadowRadius = 4
        shadowContainerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowContainerView.layer.cornerRadius = 4

        titleLabel.text = model.exercise.title ?? model.exercise.localizedTitle
        titleLabel.textColor = .baseLevelOne
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakStrategy = []

        let todayResultString = model.sets.isEmpty ?
        "notCompletedStr".localized() :
        String.makeResultString(for: model.exercise, sets: model.sets)

        todayLabel.attributedText = styledText(
            boldText: "todayStr".localized() + ": ",
            regularText: todayResultString
        )
        todayLabel.numberOfLines = 1
        todayLabel.textColor = .darkGray

        let previousResultString = model.archive.sets.isEmpty ?
        "noHistoryStr".localized() :
        String.makeResultString(for: model.exercise, sets: model.archive.sets)

        previousLabel.attributedText = styledText(
            boldText: "previousStr".localized() + ": ",
            regularText: previousResultString
        )
        previousLabel.numberOfLines = 1
        previousLabel.textColor = .darkGray

        resultContainer.layer.cornerRadius = 8

        resultLabel.textColor = .white
        resultLabel.font = .systemFont(ofSize: 14, weight: .bold)
        resultLabel.textAlignment = .center
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0.5
        resultLabel.numberOfLines = 1
        resultLabel.lineBreakMode = .byTruncatingTail

        configureResultLabel(model)
    }

    private func configureResultLabel(_ model: ExerciseResultCellModel) {
        guard let todayValue = model.sets.isEmpty ?
                nil :
                    Double(String.makeResultValue(for: model.exercise, sets: model.sets)),
              let previousValue = model.archive.sets.isEmpty ?
                nil :
                    Double(String.makeResultValue(for: model.exercise, sets: model.archive.sets)),
              previousValue != 0 else {
            resultContainer.backgroundColor = .systemRed
            resultLabel.text = "..."
            return
        }

        let percentChange = ((todayValue - previousValue) / previousValue) * 100
        let rounded = Int(percentChange.rounded())

        if rounded < 0 {
            resultContainer.backgroundColor = .systemRed
            resultLabel.text = "\(rounded)%"
        } else {
            resultContainer.backgroundColor = .systemGreen
            resultLabel.text = "+\(rounded)%"
        }
    }

    private func addViews() {
        contentView.addSubview(shadowContainerView)
        shadowContainerView.addSubview(iconImageView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(todayLabel)
        contentView.addSubview(previousLabel)
        contentView.addSubview(resultContainer)

        resultContainer.addSubview(resultLabel)
    }

    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        shadowContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(56)
        }

        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }

        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(shadowContainerView.snp.top).offset(4)
            make.leading.equalTo(shadowContainerView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
        }

        previousLabel.snp.makeConstraints { make in
            make.bottom.equalTo(shadowContainerView.snp.bottom).offset(-4)
            make.leading.equalTo(shadowContainerView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
        }

        resultContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(shadowContainerView.snp.centerY)
            make.height.equalTo(32)
            make.width.equalTo(50)
        }

        resultLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
    }

    func styledText(boldText: String, regularText: String) -> NSAttributedString {
        let fontSize: CGFloat = 15
        let color = UIColor.baseLevelOne

        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: fontSize),
            .foregroundColor: color
        ]

        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: color
        ]

        let attributedString = NSMutableAttributedString(string: boldText, attributes: boldAttributes)
        let regularAttributed = NSAttributedString(string: regularText, attributes: regularAttributes)
        attributedString.append(regularAttributed)

        return attributedString
    }
}
