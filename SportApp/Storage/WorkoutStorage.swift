import Foundation
import RxSwift
import RxRelay

final class WorkoutStorage {

    static let shared = WorkoutStorage()

    private let fileName = "Workouts.plist"
    private let workoutRelay = BehaviorRelay<[WorkoutModel]>(value: [])

    var workoutObservable: Observable<[WorkoutModel]> {
        return workoutRelay.asObservable()
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
                let data = try encoder.encode(self.workoutRelay.value)
                try data.write(to: self.plistURL)
            } catch let error {
                AnalyticsManager.shared.logError("Workout save: \(error.localizedDescription)")
            }
        }
    }

    private func loadFromPlist() {
        let url = plistURL
        let decoder = PropertyListDecoder()

        if let data = try? Data(contentsOf: url),
           let workouts = try? decoder.decode([WorkoutModel].self, from: data) {
            workoutRelay.accept(workouts)
        }
    }

    func addWorkout(_ workout: WorkoutModel) {
        var currentWorkoutList = workoutRelay.value
        currentWorkoutList.append(workout)
        workoutRelay.accept(currentWorkoutList)
        saveToPlist()
    }

    func addWorkoutFromTempl(_ workout: WorkoutModel) {
        var currentWorkoutList = workoutRelay.value
        let newWorkout = WorkoutModel(
            id: UUID(),
            title: workout.title,
            exerciseIds: workout.exerciseIds
        )

        currentWorkoutList.append(newWorkout)
        workoutRelay.accept(currentWorkoutList)
        saveToPlist()
    }

    func removeWorkout(by id: UUID) {
        // TODO: - remove by index
        var currentWorkoutList = workoutRelay.value
        currentWorkoutList.removeAll { $0.id == id }
        workoutRelay.accept(currentWorkoutList)
        saveToPlist()
    }

    func removeExercise(fromWorkouts exerciseId: UUID) {
        var currentWorkoutList = workoutRelay.value

        for index in currentWorkoutList.indices {
            currentWorkoutList[index].exerciseIds.removeAll { $0 == exerciseId }
        }

        workoutRelay.accept(currentWorkoutList)
        saveToPlist()
    }

    func updateWorkout(_ updatedWorkout: WorkoutModel) {
        var currentWorkoutList = workoutRelay.value
        if let index = currentWorkoutList.firstIndex(where: { $0.id == updatedWorkout.id }) {
            currentWorkoutList[index] = updatedWorkout
            workoutRelay.accept(currentWorkoutList)
            saveToPlist()
        }
    }

    func moveWorkout(from sourceIndex: Int, to destinationIndex: Int) {
        var currentWorkoutList = workoutRelay.value
        guard sourceIndex != destinationIndex,
              sourceIndex >= 0, sourceIndex < currentWorkoutList.count,
              destinationIndex >= 0, destinationIndex < currentWorkoutList.count else { return }

        let workout = currentWorkoutList.remove(at: sourceIndex)
        currentWorkoutList.insert(workout, at: destinationIndex)

        workoutRelay.accept(currentWorkoutList)
        saveToPlist()
    }

    func removeAllWorkouts() {
        workoutRelay.accept([])
        saveToPlist()
    }
}
