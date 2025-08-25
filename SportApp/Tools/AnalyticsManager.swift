import Foundation
import StoreKit
import FirebaseAnalytics
import Amplitude
import AppMetricaCore

final class AnalyticsManager {

    static let shared = AnalyticsManager()
    private init() {}

    // MARK: - Шаблон
    func logTemplateUsed(templateID: String) {
        Analytics.logEvent("template_used", parameters: [
            "template_id": templateID
        ])

        Amplitude.instance().logEvent("Template used", withEventProperties: [
            "template_id": templateID
        ])

        AppMetrica.reportEvent(name: "Template used")
    }

    // MARK: - Подписка
    func logSubscriptionPurchased(product: Product) {
        let price = product.price as NSDecimalNumber

        Analytics.logEvent(AnalyticsEventPurchase, parameters: [
            AnalyticsParameterItemID: product.id,
            AnalyticsParameterItemName: product.displayName,
            AnalyticsParameterItemCategory: "subscription",
            AnalyticsParameterQuantity: 1,
            AnalyticsParameterPrice: price.doubleValue,
            AnalyticsParameterCurrency: product.priceFormatStyle.currencyCode
        ])

        AppMetrica.reportEvent(name: "Subscription")
    }

    // MARK: - Создание тренировки
    func logWorkoutCreated() {
        Analytics.logEvent("workout_created", parameters: nil)

        Amplitude.instance().logEvent("Workout created")

        AppMetrica.reportEvent(name: "Workout created")
    }

    // MARK: - Создание упражнения
    func logExerciseCreated(unit: UnitType) {
        Analytics.logEvent("exercise_created", parameters: [
            "unit_type": unit.titleRu
        ])

        Amplitude.instance().logEvent("Exercise created", withEventProperties: [
            "unit_type": unit.titleRu
        ])

        AppMetrica.reportEvent(name: "Exercise created")
    }

    // MARK: - Создание меры
    func logUnitCreated(system: String) {
        Analytics.logEvent("measurement_created", parameters: [
            "system": system
        ])

        Amplitude.instance().logEvent("Measurement created", withEventProperties: [
            "system": system
        ])

        AppMetrica.reportEvent(name: "Measurement created")
    }

    // MARK: - Добавление значения меры
    func logUnitValueAdded() {
        Analytics.logEvent("unit_value_added", parameters: nil)

        Amplitude.instance().logEvent("Measurement value added")

        AppMetrica.reportEvent(name: "Measurement value added")
    }

    // MARK: - Добавление подхода
    func logSetAdded(forExerciseTitle title: String) {
        Analytics.logEvent("set_added", parameters: [
            "exercise_title": title
        ])

        Amplitude.instance().logEvent("Set added", withEventProperties: [
            "exercise_title": title
        ])

        AppMetrica.reportEvent(name: "Set added")
    }

    // MARK: - Ошибка в упражнении
    func logExerciseMistake(_ exercise: String, mistake: String) {
        Analytics.logEvent("exercise_mistake", parameters: [
            "exercise": exercise,
            "mistake": mistake
        ])

        Amplitude.instance().logEvent("Mistake reported", withEventProperties: [
            "exercise": exercise,
            "mistake": mistake
        ])

        AppMetrica.reportEvent(name: "Mistake reported")

        TelegramNotifier.send(message: "\(exercise): \(mistake)")
    }

    // MARK: - Ошибка
    func logError(_ title: String) {
        Analytics.logEvent("error", parameters: [
            "title": title
        ])

        Amplitude.instance().logEvent("Error", withEventProperties: [
            "title": title
        ])

        AppMetrica.reportEvent(name: "Error")
    }

    // MARK: - Баг
    func logFeatureRequested() {
        Analytics.logEvent("bug_report", parameters: nil)

        Amplitude.instance().logEvent("Bug reported")

        AppMetrica.reportEvent(name: "Bug reported")
    }

    // MARK: - Фича
    func logBugReported() {
        Analytics.logEvent("feature_request", parameters: nil)

        Amplitude.instance().logEvent("Feature requested")

        AppMetrica.reportEvent(name: "Feature requested")
    }
}
