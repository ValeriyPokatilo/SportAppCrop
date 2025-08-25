import Foundation
import SnapKit
import SwipeCellKit
import RxSwift

final class ActionCell: SwipeTableViewCell {

    private let actionButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(with model: ActionCellModel) {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25
        
        actionButton.setTitle(model.title, for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = model.color
        actionButton.layer.cornerRadius = 5
        actionButton.isUserInteractionEnabled = false
    }

    private func addViews() {
        contentView.addSubview(actionButton)
    }

    private func configureLayout() {
        actionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
