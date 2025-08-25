import UIKit

final class MuscleGroupButton<T: TitledEnum>: UIButton {

    private let icon = UIImageView()
    private let title = UILabel()
    private let shadowContainerView = UIView()

    private let group: T?
    private let isSelectedState: Bool

    init(group: T?, isSelected: Bool) {
        self.group = group
        self.isSelectedState = isSelected
        super.init(frame: .zero)

        addViews()
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubview(shadowContainerView)
        shadowContainerView.addSubview(icon)
        addSubview(title)
    }

    private func configureLayout() {
        shadowContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
            make.height.equalTo(shadowContainerView.snp.width)
        }

        icon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        title.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
            make.width.equalTo(CGFloat.screenWidth / 4)
        }
    }

    private func configureAppearance() {
        if group != nil {
            shadowContainerView.layer.shadowColor = UIColor.black.cgColor
            shadowContainerView.layer.shadowOpacity = 0.2
            shadowContainerView.layer.shadowRadius = 3
            shadowContainerView.layer.shadowOffset = CGSize(width: 3, height: 3)
            shadowContainerView.layer.cornerRadius = 8
            shadowContainerView.backgroundColor = .white
        }
        shadowContainerView.isUserInteractionEnabled = false

        icon.layer.borderWidth = 1
        icon.alpha = isSelectedState ? 1 : 0.3
        icon.layer.cornerRadius = 8
        icon.clipsToBounds = true
        icon.layer.borderColor = group == nil ? UIColor.clear.cgColor : UIColor.darkGray.cgColor
        icon.image = group?.image ?? UIImage()
        icon.contentMode = .scaleAspectFit

        title.text = group?.enumTitle ?? ""
        title.textAlignment = .center
        title.font = .systemFont(ofSize: 10)
    }
}
