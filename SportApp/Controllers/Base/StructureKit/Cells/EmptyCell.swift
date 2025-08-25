import UIKit

final class EmptyCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: EmptyCellModel) {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25
        contentView.backgroundColor = .baseLevelZero25
    }
}
