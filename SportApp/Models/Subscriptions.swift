import Foundation

enum Subscriptions: String {
    case proWeekly = "sport_app_weekly"
    case proMonth = "sport_app_monthly"
    case proAnnual = "sport_app_annual"

    var localizedTitle: String {
        let currentLocale = Locale.current
        return currentLocale.language.languageCode?.identifier == "ru" ? titleRu : titleEn
    }

    var titleEn: String {
        switch self {
        case .proWeekly:
            "Weekly subscription"
        case .proMonth:
            "Monthly subscription"
        case .proAnnual:
            "Annual subscription"
        }
    }

    var titleRu: String {
        switch self {
        case .proWeekly:
            "Недельная подписка"
        case .proMonth:
            "Месячная подписка"
        case .proAnnual:
            "Годовая подписка"
        }
    }
}
