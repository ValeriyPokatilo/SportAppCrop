import Foundation
import RxSwift
import RxRelay

final class ExerciseStorage {

    static let shared = ExerciseStorage()

    private let fileName = "Exercises.plist"
    private let exercisesRelay = BehaviorRelay<[ExerciseModel]>(value: [])

    var exercisesObservable: Observable<[ExerciseModel]> {
        return exercisesRelay.asObservable()
    }

    var exercises: [ExerciseModel] {
        return exercisesRelay.value
    }

    private init() {
        loadFromPlist()
    }

    private var plistURL: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent(fileName)
    }

    private func saveToPlist() {
        DispatchQueue.global(qos: .background).async {
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(self.exercisesRelay.value)
                try data.write(to: self.plistURL)
            } catch {
                AnalyticsManager.shared.logError("Exercise save error: \(error.localizedDescription)")
            }
        }
    }

    private func loadFromPlist() {
        let url = plistURL
        let decoder = PropertyListDecoder()

        if let data = try? Data(contentsOf: url),
           let exercises = try? decoder.decode([ExerciseModel].self, from: data) {
            exercisesRelay.accept(exercises.sorted {
                $0.title ?? $0.localizedTitle < $1.title ?? $1.localizedTitle
            })
        }
    }

    func addExercise(_ exercise: ExerciseModel) {
        var currentExercises = exercisesRelay.value
        currentExercises.append(exercise)
        exercisesRelay.accept(currentExercises.sorted { $0.title ?? $0.localizedTitle < $1.title ?? $1.localizedTitle })
        saveToPlist()
    }

    func removeExercise(by id: UUID) {
        var currentExercises = exercisesRelay.value
        currentExercises.removeAll { $0.id == id }
        exercisesRelay.accept(currentExercises)
        saveToPlist()
    }

    func updateExercise(_ updatedExercise: ExerciseModel) {
        var currentExercises = exercisesRelay.value
        if let index = currentExercises.firstIndex(where: { $0.id == updatedExercise.id }) {
            currentExercises[index] = updatedExercise
            exercisesRelay.accept(currentExercises)
            saveToPlist()
        }
    }

    func moveExercise(_ exercise: ExerciseModel, from: Int, to: Int) {
        var currentExercise = exercisesRelay.value

        guard from != to,
              from >= 0, from < currentExercise.count,
              to >= 0, to < currentExercise.count else {
            return
        }

        let movedExercise = currentExercise.remove(at: from)
        currentExercise.insert(movedExercise, at: to)

        exercisesRelay.accept(currentExercise)
        saveToPlist()
    }

    func moveExercise(from sourceIndex: Int, to destinationIndex: Int) {
        var currentExercise = exercisesRelay.value
        guard sourceIndex != destinationIndex,
              sourceIndex >= 0, sourceIndex < currentExercise.count,
              destinationIndex >= 0, destinationIndex < currentExercise.count else { return }

        let workout = currentExercise.remove(at: sourceIndex)
        currentExercise.insert(workout, at: destinationIndex)

        exercisesRelay.accept(currentExercise)
        saveToPlist()
    }

    func removeAllExercises() {
        exercisesRelay.accept([])
        saveToPlist()
    }
}
