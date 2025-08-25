import Foundation
import SnapKit

final class TitleCell: UITableViewCell {

    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: TitleCellModel) {
        selectionStyle = .none

        label.text = model.text
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
    }

    private func addViews() {
        contentView.addSubview(label)
    }

    private func configureLayout() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
