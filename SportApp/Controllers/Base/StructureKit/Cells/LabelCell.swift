import Foundation
import SnapKit

final class LabelCell: UITableViewCell {

    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: LabelCellModel) {
        selectionStyle = .none
        backgroundColor = model.background

        label.text = model.text
        label.textColor = model.color
        label.font = .systemFont(ofSize: model.size, weight: model.weight)
        label.textAlignment = model.alignment
        label.numberOfLines = 0
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
