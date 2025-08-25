import Foundation
import SnapKit
import SwipeCellKit

final class ExerciseListCell: SwipeTableViewCell {

    private let iconImageView = UIImageView()
    private let shadowContainerView = UIView()

    private let titleLabel = UILabel()
    private let line1Label = UILabel()
    private let line2Label = UILabel()
    private let line3Label = UILabel()

    private var deleteActionTitle: String = "deleteStr".localized()
    private var deleteSwipeAction: EmptyBlock?
    private var editSwipeAction: EmptyBlock?
    private var canEdit = true
    private var canRemove = true

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ExerciseListCellModel) {
        backgroundColor = .baseLevelZero25
        delegate = self

        if let icon = UIImage(named: model.exercise.iconName ?? "") {
            iconImageView.image = icon
        } else {
            iconImageView.image = UIImage(named: "_defaultIcon")
        }
        iconImageView.layer.cornerRadius = 8
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.darkGray.cgColor
        iconImageView.clipsToBounds = true

        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.2
        shadowContainerView.layer.shadowRadius = 4
        shadowContainerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowContainerView.layer.cornerRadius = 4

        titleLabel.text = model.exercise.title ?? model.exercise.localizedTitle
        titleLabel.textColor = .baseLevelOne
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakStrategy = []

        line1Label.text = ExerciseStringService.makeMuscleString(model.exercise)
        line1Label.font = .systemFont(ofSize: 13, weight: .regular)
        line1Label.numberOfLines = 1
        line1Label.textColor = .darkGray

        line2Label.text = ExerciseStringService.makeEqString(model.exercise)
        line2Label.font = .systemFont(ofSize: 13, weight: .regular)
        line2Label.numberOfLines = 1
        line2Label.textColor = .darkGray

        line3Label.text = ExerciseStringService.makeDescString(model.exercise)
        line3Label.font = .systemFont(ofSize: 13)
        line3Label.numberOfLines = 1
        line3Label.textColor = .darkGray

        deleteActionTitle = model.deleteTitle
        deleteSwipeAction = model.deleteSwipeAction
        editSwipeAction = model.editSwipeAction
        canEdit = model.canEdit
        canRemove = model.canRemove
    }

    private func addViews() {
        contentView.addSubview(shadowContainerView)
        shadowContainerView.addSubview(iconImageView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(line1Label)
        contentView.addSubview(line2Label)
        contentView.addSubview(line3Label)
    }

    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        shadowContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(54)
        }

        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        line1Label.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
        }

        line2Label.snp.makeConstraints { make in
            make.top.equalTo(line1Label.snp.bottom).offset(3)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
        }

        line3Label.snp.makeConstraints { make in
            make.top.equalTo(line2Label.snp.bottom).offset(3)
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}

extension ExerciseListCell: SwipeTableViewCellDelegate {
    func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath,
        for orientation: SwipeCellKit.SwipeActionsOrientation
    ) -> [SwipeCellKit.SwipeAction]? {

        guard orientation == .right else {
            return nil
        }

        let deleteSwipeAction = SwipeAction(style: .default, title: deleteActionTitle) { [weak self] _, _ in
            self?.hideSwipe(animated: true, completion: { [weak self] _ in
                self?.deleteSwipeAction?()
            })
        }

        let editSwipeAction = SwipeAction(style: .default, title: "editStr".localized()) { [weak self] _, _ in
            self?.hideSwipe(animated: true, completion: { [weak self] _ in
                self?.editSwipeAction?()
            })
        }

        deleteSwipeAction.image = .trashImg
        deleteSwipeAction.backgroundColor = .systemRed
        deleteSwipeAction.font = .systemFont(ofSize: 14)

        editSwipeAction.image = .editImg
        editSwipeAction.backgroundColor = .lightGray
        editSwipeAction.font = .systemFont(ofSize: 14)

        if canEdit {
            return [deleteSwipeAction, editSwipeAction]
        } else if canRemove {
            return [deleteSwipeAction]
        } else {
            return []
        }
    }
}
