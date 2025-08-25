import Foundation

struct Template: Identifiable, Codable, Hashable {
    var id = UUID()
    var titleRu: String?
    var titleEn: String?
    var level: Level
    var descRu: String?
    var descEn: String?
    var image: String
    var workouts: [WorkoutModel]

    var localizedTitle: String {
        let currentLocale = Locale.current
        return currentLocale.language.languageCode?.identifier == "ru" ? titleRu ?? "" : titleEn ?? ""
    }

    var localizedDesc: String {
        let currentLocale = Locale.current
        return currentLocale.language.languageCode?.identifier == "ru" ? descRu ?? "" : descEn ?? ""
    }
}
