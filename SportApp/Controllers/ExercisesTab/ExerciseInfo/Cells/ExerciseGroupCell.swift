import Foundation
import SnapKit

final class ExerciseGroupCell: UITableViewCell {

    private var container = UIView(frame: .zero)

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
        container.subviews.forEach { $0.removeFromSuperview() }
    }

    func configure(with model: ExerciseGroupCellModel) {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25

        if let eq = model.equipmentImages {
            container.addSubview(eq)
            eq.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
            }
        }

        if let ms = model.muscleImages {
            container.addSubview(ms)
            ms.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
            }
        }

        layoutIfNeeded()
    }

    private func addViews() {
        contentView.addSubview(container)
    }

    private func configureLayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
