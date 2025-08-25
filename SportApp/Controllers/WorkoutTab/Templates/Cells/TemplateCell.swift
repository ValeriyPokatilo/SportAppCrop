import Foundation
import SnapKit

final class TemplateCell: UITableViewCell {

    private let containerView = UIView()
    private let stackView = UIStackView()
    private let iconImage = UIImageView()
    private let titleLabel = UILabel()
    private let levelLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureAppearance()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25

        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4

        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .baseLevelZero
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView.layer.borderColor = UIColor.systemGreen.cgColor

        iconImage.layer.cornerRadius = 12
        iconImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        iconImage.clipsToBounds = true
        iconImage.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)

        levelLabel.font = .systemFont(ofSize: 12)
        levelLabel.numberOfLines = 0
        levelLabel.setContentHuggingPriority(.required, for: .horizontal)

        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .baseLevelB
    }

    func configure(with model: TemplateCellModel) {
        titleLabel.text = model.template.localizedTitle
        levelLabel.text = "levelStr".localized() + ": " + model.template.level.localizedTitle
        descriptionLabel.text = model.template.localizedDesc
        iconImage.image = UIImage(named: model.template.image)
    }

    private func addViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImage)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(levelLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }

    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(96)
        }

        iconImage.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(iconImage.snp.height)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
            make.leading.equalTo(iconImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
}
