import UIKit
import RxSwift
import RxCocoa

final class CheckBoxCell: UITableViewCell {

    private let checkBox = UIButton()
    private var title = UILabel()
    private let disposeBag = DisposeBag()
    private var didCheckboxAction: ParameterBlock<Bool>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(checkBox.snp.leading).offset(-8)
        }

        checkBox.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(20)
            make.centerY.equalTo(title.snp.centerY)
        }
    }

    private func addViews() {
        contentView.addSubview(title)
        contentView.addSubview(checkBox)
    }

    @IBAction private func checkBoxAction() {
        didCheckboxAction?(!checkBox.isSelected)
    }

    func configure(with model: CheckBoxCellModel) {
        selectionStyle = .none

        title.text = model.title

        checkBox.setTitle("", for: .normal)
        checkBox.layer.cornerRadius = 3.0
        checkBox.clipsToBounds = true
        checkBox.setImage(.checkMarkFillImg, for: .selected)
        checkBox.setImage(.checkMarkEmptyImg, for: .normal)

        didCheckboxAction = model.checkboxAction
        model.selected.bind(to: checkBox.rx.isSelected).disposed(by: disposeBag)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        checkBoxAction()
    }
}
