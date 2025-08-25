import UIKit

enum MuscleGroup: String, CaseIterable, Codable, TitledEnum {

    static var allTitle: String = "allMusclesStr".localized()

    case chest
    case back
    case legs
    case arms
    case shoulders
    case coreAbs
    case neck
    case cardio
    case other

    var title: String {
        rawValue.mgLocalized()
    }

    var image: UIImage? {
        UIImage(named: rawValue)
    }

    var enumTitle: String {
        title
    }
}
