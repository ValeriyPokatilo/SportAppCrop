import SnapKit
import RxSwift

final class UnitTypeCell: UITableViewCell {

    private let segmentedControl = UISegmentedControl(items: UnitType.allCases.map { $0.title })

    var valueChanged: ParameterBlock<UnitType>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: UnitTypeCellModel) {
        selectionStyle = .none
        backgroundColor = .baseLevelZero25

        if let selectedSegmentIndex = model.selectedSegmentIndex {
            segmentedControl.selectedSegmentIndex = selectedSegmentIndex
        }
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
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

    @objc private func segmentValueChanged() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        if let selectedOption = UnitType.allCases.dropFirst(selectedIndex).first {
            
            valueChanged?(selectedOption)
        }
    }
}
