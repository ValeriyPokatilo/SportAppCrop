import UIKit

struct ExerciseModel: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String?
    var titleRu: String?
    var titleEn: String?
    var unitType: UnitType
    var muscleGroups: [MuscleGroup]?
    var equipment: [Equipment]?
    var iconName: String?
    var imageName: String?
    var canEdit: Bool?

    var localizedTitle: String {
        let currentLocale = Locale.current
        return currentLocale.language.languageCode?.identifier == "ru" ? titleRu ?? title ?? "" : titleEn ?? title ?? ""
    }
}
