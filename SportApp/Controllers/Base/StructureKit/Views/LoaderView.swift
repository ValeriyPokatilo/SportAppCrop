import UIKit

final class LoaderView: UIView {

    private let loader = UIActivityIndicatorView(style: .large)

    init() {
        super.init(frame: .zero)

        addViews()
        configureAppearance()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubview(loader)
    }

    private func configureAppearance() {
        backgroundColor = .baseLevelZero25
        loader.startAnimating()
    }

    private func configureLayout() {
        loader.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }
    }
}
