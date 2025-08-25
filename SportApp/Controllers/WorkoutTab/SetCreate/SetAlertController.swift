import UIKit

final class SetAlertController: UIViewController {

    private let exercise: ExerciseModel
    private let set: SetEntity?

    init(exercise: ExerciseModel, set: SetEntity?) {
        self.exercise = exercise
        self.set = set
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        switch exercise.unitType {
        case .withWeight:
            self.view = SetInputView(parent: self, exercise: exercise, set: set)
        case .withoutWeight:
            self.view = SetInputView(parent: self, exercise: exercise, set: set)
        case .timer:
            self.view = TimerView(parent: self, exercise: exercise, set: set)
        case .distance:
            self.view = SetInputView(parent: self, exercise: exercise, set: set)
        }
    }
}
