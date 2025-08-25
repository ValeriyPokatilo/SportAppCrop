import Foundation

struct Benefits {
    static var benefitsString: String {
        let currentLocale = Locale.current
        let isRussian = currentLocale.language.languageCode?.identifier == "ru"

        let titleRu = """
        Подписка PRO открывает доступ к дополнительным функциям:
        • Использование шаблонов тренировок
        • Создание неограниченного количества тренировок
        • Создание неограниченного количества замеров
        • Создание новых упражнений
        """
        // • Отсутствие рекламы // TODO: - add ads

        let titleEn = """
        PRO Subscription unlocks additional features:
        • Use of workout templates
        • Create unlimited workouts
        • Create unlimited measurements
        • Creating New Exercises
        """
        // • No ads // TODO: - add ads

        return isRussian ? titleRu : titleEn
    }
}
