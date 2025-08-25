import Foundation
import SnapKit
import RxSwift

final class MuscleGroupCell: UITableViewCell {

    private let stackView = UIStackView()
    private var disposeBag = DisposeBag()
    private var valueChanged: ParameterBlock<MuscleGroup>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.removeAllArrangedSubviews()
        disposeBag = DisposeBag()
    }

    func configure(with model: MuscleGroupCellModel) {
        backgroundColor = .baseLevelZero25
        selectionStyle = .none

        valueChanged = model.valueChanged

        let group1 = MuscleGroupButton(group: model.group1, isSelected: model.group1Selected)
        group1.rx.tap.subscribe { [weak self] _ in
            self?.valueChanged?(model.group1)
        }
        .disposed(by: disposeBag)

        let group2 = MuscleGroupButton(group: model.group2, isSelected: model.group2Selected)
        group2.rx.tap.subscribe { [weak self] _ in
            self?.valueChanged?(model.group2)
        }
        .disposed(by: disposeBag)

        let group3 = MuscleGroupButton(group: model.group3, isSelected: model.group3Selected)
        group3.rx.tap.subscribe { [weak self] _ in
            self?.valueChanged?(model.group3)
        }
        .disposed(by: disposeBag)

        stackView.addArrangedSubview(group1)
        stackView.addArrangedSubview(group2)
        stackView.addArrangedSubview(group3)
    }

    private func addViews() {
        contentView.addSubview(stackView)
    }

    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    private func configureAppearance() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
    }
}
