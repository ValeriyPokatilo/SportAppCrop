import Foundation
import SnapKit
import SwipeCellKit

final class WorkoutCell: SwipeTableViewCell {

    private let titleLabel = UILabel()
    private let workoutsLabel = UILabel()

    private var deleteSwipeAction: EmptyBlock?
    private var editSwipeAction: EmptyBlock?
    private var moveWorkoutToArchive: EmptyBlock?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: WorkoutCellModel) {
        backgroundColor = .baseLevelZero25
        delegate = self

        titleLabel.text = model.workout.title
        titleLabel.textColor = .baseLevelOne
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 1

        workoutsLabel.text = model
            .workout
            .getExercises().map({ $0.title ?? $0.localizedTitle })
            .joined(separator: ", ")
        workoutsLabel.font = .systemFont(ofSize: 14)
        workoutsLabel.numberOfLines = 0
        workoutsLabel.textColor = .baseLevelB

        deleteSwipeAction = model.deleteSwipeAction
        editSwipeAction = model.editSwipeAction
        moveWorkoutToArchive = model.moveWorkoutToArchive
    }

    private func addViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(workoutsLabel)
    }

    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalTo(workoutsLabel.snp.top).offset(-4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        workoutsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}

extension WorkoutCell: SwipeTableViewCellDelegate {
    func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath,
        for orientation: SwipeCellKit.SwipeActionsOrientation
    ) -> [SwipeCellKit.SwipeAction]? {

        guard orientation == .right else {
            return nil
        }

        let deleteSwipeAction = SwipeAction(style: .default, title: "deleteStr".localized()) { [weak self] _, _ in
            self?.hideSwipe(animated: true, completion: { [weak self] _ in
                self?.deleteSwipeAction?()
            })
        }

        let editSwipeAction = SwipeAction(style: .default, title: "editStr".localized()) { [weak self] _, _ in
            self?.hideSwipe(animated: true, completion: { [weak self] _ in
                self?.editSwipeAction?()
            })
        }

        let archiveSwipeAction = SwipeAction(style: .default, title: "toArchiveStr".localized()) { [weak self] _, _ in
            self?.hideSwipe(animated: true, completion: { [weak self] _ in
                self?.moveWorkoutToArchive?()
            })
        }

        deleteSwipeAction.image = .trashImg
        deleteSwipeAction.backgroundColor = .systemRed
        deleteSwipeAction.font = .systemFont(ofSize: 14)

        editSwipeAction.image = .editImg
        editSwipeAction.backgroundColor = .lightGray
        editSwipeAction.font = .systemFont(ofSize: 14)

        archiveSwipeAction.image = .templateImg
        archiveSwipeAction.backgroundColor = .systemOrange
        archiveSwipeAction.font = .systemFont(ofSize: 14)

        return [deleteSwipeAction, archiveSwipeAction, editSwipeAction]
    }
}
