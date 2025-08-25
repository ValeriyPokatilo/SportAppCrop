import CoreData
import RxSwift

final class CoreDataManager {

    static let shared = CoreDataManager()

    let context: NSManagedObjectContext

    private let setSubject = BehaviorSubject<[SetEntity]>(value: [])

    var setsObservable: Observable<[SetEntity]> {
        return setSubject.asObservable()
            .observe(on: MainScheduler.instance)
    }

    init() {
        let container = NSPersistentContainer(name: "SportApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        context = container.viewContext

        fetchTodaySets()
    }

    func fetchTodaySets() {
        let fetchRequest: NSFetchRequest<SetEntity> = SetEntity.fetchRequest()

        let startOfDay = Calendar.current.startOfDay(for: Date())
        fetchRequest.predicate = NSPredicate(format: "timeStamp >= %@", startOfDay as NSDate)

        do {
            let result = try context.fetch(fetchRequest)
            setSubject.onNext(result)
        } catch {
            setSubject.onError(error)
        }
    }

    func saveSet(entity: SetEntity?, model: SetModel) {
        let element: SetEntity

        if let entity {
            element = entity
        } else {
            element = SetEntity(context: context)
            element.id = UUID()
        }

        element.timeStamp = model.timeStamp
        element.weight = model.weight
        element.reps = Int64(model.reps)
        element.exerciseId = model.exerciseId

        do {
            try context.save()
            fetchTodaySets()
        } catch let error {
            AnalyticsManager.shared.logError("Save set error - \(error.localizedDescription)")
        }
    }

    func removeSet(set: SetEntity) {
        context.delete(set)

        do {
            try context.save()
            fetchTodaySets()
        } catch let error {
            AnalyticsManager.shared.logError("Remove set error - \(error.localizedDescription)")
        }
    }

    func removeAllSets(for exerciseId: UUID) {
        let fetchRequest: NSFetchRequest<SetEntity> = SetEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "exerciseId == %@", exerciseId as CVarArg)

        do {
            let setsToDelete = try context.fetch(fetchRequest)
            for set in setsToDelete {
                context.delete(set)
            }

            try context.save()
            fetchTodaySets()
        } catch {
            AnalyticsManager.shared.logError("Remove all sets error - \(error.localizedDescription)")
        }
    }

    func shiftAllSetsOneDayBack() {
        let fetchRequest: NSFetchRequest<SetEntity> = SetEntity.fetchRequest()

        do {
            let allSets = try context.fetch(fetchRequest)
            let calendar = Calendar.current

            for set in allSets {
                if let timestamp = set.timeStamp {
                    set.timeStamp = calendar.date(byAdding: .day, value: -3, to: timestamp)
                }
            }

            try context.save()
            fetchTodaySets()
        } catch {
            AnalyticsManager.shared.logError("Shift sets error - \(error.localizedDescription)")
        }
    }

    func fetchPreviousWorkoutSets(for exerciseId: UUID) -> SetArchive {
        let fetchRequest: NSFetchRequest<SetEntity> = SetEntity.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        fetchRequest.predicate = NSPredicate(
            format: "exerciseId == %@ AND timeStamp < %@",
            exerciseId as CVarArg, Calendar.current.startOfDay(for: Date()) as NSDate
        )

        do {
            let allSets = try context.fetch(fetchRequest)

            if let lastWorkoutDate = allSets.first?.timeStamp {
                let lastWorkoutStart = Calendar.current.startOfDay(for: lastWorkoutDate)
                let lastWorkoutEnd = Calendar.current.date(byAdding: .day, value: 1, to: lastWorkoutStart)!

                let lastWorkoutPredicate = NSPredicate(
                    format: "exerciseId == %@ AND timeStamp >= %@ AND timeStamp < %@",
                    exerciseId as CVarArg, lastWorkoutStart as NSDate, lastWorkoutEnd as NSDate
                )
                fetchRequest.predicate = lastWorkoutPredicate
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]

                let previousWorkoutSets = try context.fetch(fetchRequest)
                return SetArchive(date: lastWorkoutStart, sets: previousWorkoutSets)
            } else {
                return SetArchive(date: Date(), sets: [])
            }
        } catch {
            AnalyticsManager.shared.logError("Fetch previous workout sets error - \(error.localizedDescription)")
            return SetArchive(date: Date(), sets: [])
        }
    }

    func fetchWorkoutSetsGroupedByDate(for exerciseId: UUID) -> [SetArchive] {
        let fetchRequest: NSFetchRequest<SetEntity> = SetEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "exerciseId == %@", exerciseId as CVarArg)

        do {
            let allSets = try context.fetch(fetchRequest)

            let groupedSets = Dictionary(grouping: allSets) { set in
                Calendar.current.startOfDay(for: set.timeStamp ?? Date())
            }

            let archives = groupedSets.map { (date, sets) in
                let sortedSets = sets.sorted { ($0.timeStamp ?? Date()) < ($1.timeStamp ?? Date()) }
                return SetArchive(date: date, sets: sortedSets)
            }

            return archives.sorted { $0.date > $1.date }
        } catch {
            AnalyticsManager.shared.logError("Fetch workout sets grouped by date error - \(error.localizedDescription)")
            return []
        }
    }
}
