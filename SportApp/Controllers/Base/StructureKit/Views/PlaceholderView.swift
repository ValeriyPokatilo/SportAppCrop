import UIKit

final class PlaceholderView: UIView {

    private let title: String
    private let showButton: Bool
    private let createBlock: EmptyBlock?

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let plusImage = UIImageView(image: .plusCircleImg)

    init(title: String, showButton: Bool = true, createBlock: EmptyBlock?) {
        self.title = title
        self.showButton = showButton
        self.createBlock = createBlock
        super.init(frame: .zero)

        addViews()
        configureAppearance()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        if showButton {
            stackView.addArrangedSubview(plusImage)
        }
    }

    private func configureAppearance() {
        backgroundColor = .baseLevelZero25

        stackView.axis = .vertical
        stackView.spacing = 16

        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(plusTapped)
        )
        plusImage.isUserInteractionEnabled = true
        plusImage.addGestureRecognizer(tapGesture)
        plusImage.contentMode = .scaleAspectFit
        plusImage.tintColor = .systemGreen
    }

    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }

        plusImage.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
    }

    @objc private func plusTapped() {
        createBlock?()
    }
}
