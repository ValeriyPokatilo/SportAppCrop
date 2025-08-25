import UIKit

enum UnitType: String, TitledEnum, Codable, CaseIterable {

    static var allTitle: String = "allUnitTypeStr".localized()

    case withWeight
    case withoutWeight
    case timer
    case distance

    var title: String {
        switch self {
        case .withWeight:
            "withWeightTitleStr".localized()
        case .withoutWeight:
            "withoutWeightTitleStr".localized()
        case .timer:
            "timerTitleStr".localized()
        case .distance:
            "distanceTitleStr".localized()
        }
    }

    var image: UIImage? {
        nil
    }

    var enumTitle: String {
        title
    }

    var showWeight: Bool {
        switch self {
        case .withWeight:
            true
        case .withoutWeight:
            false
        case .timer:
            false
        case .distance:
            true
        }
    }

    var descriptionWeight: String {
        switch self {
        case .withWeight:
            ConfStorage.shared.conf.defaultUnit.weight
        case .withoutWeight:
            "repsStr".localized()
        case .timer:
            ConfStorage.shared.conf.defaultUnit.time
        case .distance:
            ConfStorage.shared.conf.defaultUnit.distance
        }
    }

    var descriptionReps: String {
        switch self {
        case .withWeight:
            String("repsStr").localized()
        case .withoutWeight:
            String("repsStr").localized()
        case .timer:
            String("secStr").localized()
        case .distance:
            String("minStr").localized()
        }
    }

    var titleRu: String {
        switch self {
        case .withWeight:
            "С весом"
        case .withoutWeight:
            "Без веса"
        case .timer:
            "Таймер"
        case .distance:
            "Дистанция"
        }
    }
}
