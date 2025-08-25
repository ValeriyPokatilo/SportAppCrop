import Foundation
import SnapKit
import SwipeCellKit

final class IconActionCell: SwipeTableViewCell {

    private let actionButton = UIButton(type: .system)
    private var tapAction: EmptyBlock?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: IconActionCellModel) {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25

        actionButton.setImage(model.image, for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.tintColor = model.color

        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
            pointSize: 32
        )

        actionButton.configuration = config
        actionButton.addTarget(self, action: #selector(actionApped), for: .touchUpInside)

        tapAction = model.tapAction
    }

    private func addViews() {
        contentView.addSubview(actionButton)
    }

    private func configureLayout() {
        actionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    @objc private func actionApped() {
        tapAction?()
    }
}
