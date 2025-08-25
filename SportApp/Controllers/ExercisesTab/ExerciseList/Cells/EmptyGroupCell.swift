import Foundation
import SnapKit

final class EmptyGroupCell: UITableViewCell {

    private let container = UIView()
    private let icon = UIImageView()
    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: EmptyGroupCellModel) {
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.2
        container.layer.shadowRadius = 3
        container.layer.shadowOffset = CGSize(width: 3, height: 3)
        container.layer.cornerRadius = 8
        container.backgroundColor = .white
    }

    private func addViews() {
        contentView.addSubview(label)
        contentView.addSubview(container)
        container.addSubview(icon)
    }

    private func configureLayout() {
        container.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(64)
        }

        icon.snp.makeConstraints { make in
            make.size.equalTo(34)
            make.center.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalTo(container.snp.leading)
            make.trailing.equalTo(container.snp.trailing)
        }
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25

        icon.image = .plusImg
        icon.tintColor = .systemGreen

        label.text = "addStr".localized()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10)
    }
}
