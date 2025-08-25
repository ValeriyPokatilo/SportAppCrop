import SnapKit

final class MainListCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: MainListCellModel) {
        selectionStyle = .none
        backgroundColor = .baseLevelZero

        stackView.axis = .vertical
        stackView.spacing = 8

        titleLabel.text = model.title
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)

        descriptionLabel.text = model.description
        descriptionLabel.font = .systemFont(ofSize: 12)
    }

    private func addViews() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        addSubview(stackView)
    }

    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
