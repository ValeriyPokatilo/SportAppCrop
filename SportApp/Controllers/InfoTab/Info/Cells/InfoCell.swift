import Foundation
import SnapKit

final class InfoCell: UITableViewCell {

    private let titleLabel = UILabel()
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

    func configure(with model: InfoCellModel) {
        titleLabel.text = model.item.title
        descriptionLabel.text = model.item.description
    }

    private func configureAppearance() {
        backgroundColor = .baseLevelZero25
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
    }

    private func addViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
