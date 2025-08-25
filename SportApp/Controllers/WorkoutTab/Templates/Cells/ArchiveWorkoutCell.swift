import Foundation
import SnapKit
import SwipeCellKit

final class ArchiveWorkoutCell: SwipeTableViewCell {

    private let titleLabel = UILabel()
    private let workoutsLabel = UILabel()

    private var deleteSwipeAction: EmptyBlock?
    private var moveWorkoutFromArchive: EmptyBlock?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ArchiveWorkoutCellModel) {
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
        moveWorkoutFromArchive = model.moveWorkoutFromArchive
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

extension ArchiveWorkoutCell: SwipeTableViewCellDelegate {
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

        let archiveSwipeAction = SwipeAction(style: .default, title: "fromArchiveStr".localized()) { [weak self] _, _ in
            self?.hideSwipe(animated: true, completion: { [weak self] _ in
                self?.moveWorkoutFromArchive?()
            })
        }

        deleteSwipeAction.image = .trashImg
        deleteSwipeAction.backgroundColor = .systemRed
        deleteSwipeAction.font = .systemFont(ofSize: 14)

        archiveSwipeAction.image = .templateImg
        archiveSwipeAction.backgroundColor = .systemOrange
        archiveSwipeAction.font = .systemFont(ofSize: 14)

        return [deleteSwipeAction, archiveSwipeAction]
    }
}
