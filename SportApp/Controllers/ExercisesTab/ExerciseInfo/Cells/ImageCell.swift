import Foundation
import SnapKit

final class ImageCell: UITableViewCell {

    private let exerciseImage = UIImageView()
    private let shadowContainerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ImageCellModel) {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25

        let imageName = model.imageName ?? "_defaultImage"
        let image = UIImage(named: imageName) ?? UIImage(named: "_defaultImage")!

        exerciseImage.image = image
        exerciseImage.layer.cornerRadius = 12
        exerciseImage.clipsToBounds = true
        exerciseImage.contentMode = .scaleAspectFit

        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.2
        shadowContainerView.layer.shadowRadius = 4
        shadowContainerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowContainerView.layer.cornerRadius = 12

        let aspectRatio = image.size.height / image.size.width
        let screenWidth = UIScreen.main.bounds.width - 40

        shadowContainerView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(screenWidth * aspectRatio)
            make.bottom.equalToSuperview().offset(-8).priority(.low)
        }

        exerciseImage.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func addViews() {
        contentView.addSubview(shadowContainerView)
        shadowContainerView.addSubview(exerciseImage)
    }
}
