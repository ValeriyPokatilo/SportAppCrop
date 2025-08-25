import UIKit
import SnapKit

final class MuscleButton<T: TitledEnum>: UIButton {

    private let stackView = UIStackView(frame: .zero)

    init(groups: [T]) {
        super.init(frame: .zero)

        addViews()
        configureLayout()
        configureAppearance()
        update(groups: groups)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubview(stackView)
    }

    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
    }

    private func configureAppearance() {
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.isUserInteractionEnabled = false
    }

    func update(groups: [T]) {
        stackView.removeAllArrangedSubviews()

        let limit = 4
        let filledGroups: [T?] = {
            var result = groups.map { Optional($0) }
            while result.count < limit {
                result.append(nil)
            }
            return result
        }()

        filledGroups.prefix(limit).forEach {
            let button = MuscleGroupButton<T>(group: $0, isSelected: true)
            stackView.addArrangedSubview(button)
        }
    }
}
