import CoreData
import RxSwift

final class IndicatorsStorage {

    static let shared = IndicatorsStorage()

    let context: NSManagedObjectContext

    private let indicatorsSubject = BehaviorSubject<[IndicatorEntity]>(value: [])

    var indicatorsObservable: Observable<[IndicatorEntity]> {
        return indicatorsSubject.asObservable()
            .observe(on: MainScheduler.instance)
    }

    init() {
        let container = NSPersistentContainer(name: "Indicators")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        context = container.viewContext

        fetchIndicators()
    }

    private func fetchIndicators() {
        let fetchRequest: NSFetchRequest<IndicatorEntity> = IndicatorEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        do {
            let indicators = try context.fetch(fetchRequest)
            indicatorsSubject.onNext(indicators)
        } catch {
            print("Ошибка загрузки индикаторов: \(error)")
            indicatorsSubject.onNext([])
        }
    }

    func saveIndicator(entity: IndicatorEntity?, title: String, unit: String) {
        let element: IndicatorEntity

        if let entity {
            element = entity
        } else {
            element = IndicatorEntity(context: context)
            element.id = UUID()
            element.order = getNextOrder()
        }

        element.title = title
        element.unit = unit

        do {
            try context.save()
            fetchIndicators()
        } catch let error {
            AnalyticsManager.shared.logError("Save indicator error - \(error.localizedDescription)")
        }
    }

    func saveRecord(entity: RecordEntity?, indicator: IndicatorEntity?, value: Double) {
        let element: RecordEntity

        if let entity {
            element = entity
        } else {
            element = RecordEntity(context: context)
            element.id = UUID()
            element.timestamp = Date()
        }

        element.value = value
        element.indicator = indicator

        do {
            try context.save()
            fetchIndicators()
        } catch let error {
            AnalyticsManager.shared.logError("Save record error - \(error.localizedDescription)")
        }
    }

    func deleteIndicator(_ indicator: IndicatorEntity) {
        context.delete(indicator)

        do {
            try context.save()
            fetchIndicators()
        } catch let error {
            AnalyticsManager.shared.logError("Remove indicator error - \(error.localizedDescription)")
        }
    }

    func deleteRecord(_ record: RecordEntity) {
        context.delete(record)

        do {
            try context.save()
            fetchIndicators()
        } catch let error {
            AnalyticsManager.shared.logError("Remove record error - \(error.localizedDescription)")
        }
    }

    func moveRows(from id1: UUID, to id2: UUID) {
        guard let indicators = try? indicatorsSubject.value(),
              let fromIndex = indicators.firstIndex(where: { $0.id == id1 }),
              let toIndex = indicators.firstIndex(where: { $0.id == id2 }) else {
            return
        }

        let tempOrder = indicators[fromIndex].order
        indicators[fromIndex].order = indicators[toIndex].order
        indicators[toIndex].order = tempOrder

        do {
            try context.save()
            indicatorsSubject.onNext(indicators)
            fetchIndicators()
        } catch {
            AnalyticsManager.shared.logError("Move indiator rows error - \(error.localizedDescription)")
        }
    }

    private func getNextOrder() -> Int16 {
        let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "IndicatorEntity")
        fetchRequest.resultType = .dictionaryResultType

        let keyPathExpression = NSExpression(forKeyPath: "order")
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keyPathExpression])

        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "maxOrder"
        expressionDescription.expression = maxExpression
        expressionDescription.expressionResultType = .integer16AttributeType

        fetchRequest.propertiesToFetch = [expressionDescription]

        do {
            let result = try context.fetch(fetchRequest)
            let maxOrder = (result.first?["maxOrder"] as? Int16) ?? -1
            return maxOrder + 1
        } catch {
            print("Ошибка вычисления максимального order: \(error)")
            return 0
        }
    }

    func shiftRecordsBy(days: Int) {
        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()

        do {
            let records = try context.fetch(fetchRequest)
            let calendar = Calendar.current

            for record in records {
                if let timestamp = record.timestamp {
                    record.timestamp = calendar.date(byAdding: .day, value: -days, to: timestamp)
                }
            }

            try context.save()
            fetchIndicators()
        } catch {
            AnalyticsManager.shared.logError("Shift records error - \(error.localizedDescription)")
        }
    }

}
