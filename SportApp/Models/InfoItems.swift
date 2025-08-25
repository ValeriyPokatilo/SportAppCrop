import Foundation

enum InfoItems {
    case indicators
    case defaultUnits
    case feature
    case bug
    case subscriptions
    case debugMenu

    var title: String {
        switch self {
        case .indicators:
            "indicatorsStr".localized()
        case .defaultUnits:
            "defUnitsTitleStr".localized()
        case .feature:
            "requestFeatureStr".localized()
        case .bug:
            "reportBugStr".localized()
        case .subscriptions:
            "subscriptionsStr".localized()
        case .debugMenu:
            "Debug menu"
        }
    }

    var description: String {
        switch self {
        case .indicators:
            "indicatorsStrDesc".localized()
        case .defaultUnits:
            ConfStorage.shared.conf.defaultUnit.title
        case .feature:
            "requestFeatureStrDesc".localized()
        case .bug:
            "reportBugStrDesc".localized()
        case .subscriptions:
            "purchaseDescStr".localized()
        case .debugMenu:
            "Description"
        }
    }
}
