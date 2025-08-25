import Foundation
import SnapKit

final class TemplateSegmentedCell: UITableViewCell {

    var valueChanged: ParameterBlock<Int>?

    private let segmentedControl = UISegmentedControl(items: [
        "templatesStr".localized(),
        "archiveStr".localized()
    ])

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: TemplateSegmentedCellModel) {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25

        segmentedControl.selectedSegmentIndex = model.index
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    private func addViews() {
        contentView.addSubview(segmentedControl)
    }

    private func configureLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    @objc private func segmentChanged() {
        valueChanged?(segmentedControl.selectedSegmentIndex)
    }
}
