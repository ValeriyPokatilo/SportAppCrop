import Foundation

enum Level: String, Codable {
    case junior
    case middle
    case senior

    var localizedTitle: String {
        let currentLocale = Locale.current
        return currentLocale.language.languageCode?.identifier == "ru" ? titleRu : titleEn
    }

    var titleRu: String {
        switch self {
        case .junior:
            return "Новичок"
        case .middle:
            return "Средний"
        case .senior:
            return "Продвинутый"
        }
    }

    var titleEn: String {
        switch self {
        case .junior:
            return "Beginner"
        case .middle:
            return "Intermediate"
        case .senior:
            return "Advanced"
        }
    }
}
