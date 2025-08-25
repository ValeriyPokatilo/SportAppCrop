import Foundation
import CoreData

final class ResetManager {

    static let shared = ResetManager()

    private init() {}

    func resetAll() {
        resetUserDefaults()
        resetCoreData()
        resetFiles()
    }

    func resetUserDefaults() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }

    func resetCoreData() {
        let context = CoreDataManager.shared.context

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SetEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("✅ Core Data очищена")
        } catch {
            print("❌ Ошибка очистки Core Data: \(error)")
        }
    }

    func resetFiles() {
        WorkoutStorage.shared.removeAllWorkouts()
        ExerciseStorage.shared.removeAllExercises()
    }
}
