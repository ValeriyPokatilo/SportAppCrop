import Foundation

enum MSystem: String, CaseIterable, Codable {
    case metric
    case imperial
    case unknow

    var title: String {
        switch self {
        case .metric:
            return "metricTitleStr".localized()
        case .imperial:
            return "imperialTitleStr".localized()
        case .unknow:
            return ""
        }
    }

    var titleRu: String {
        switch self {
        case .metric:
            return "Метрическая"
        case .imperial:
            return "Имперская"
        case .unknow:
            return "Неизвестно"
        }
    }

    var weight: String {
        switch self {
        case .metric:
            return "kgStr".localized()
        case .imperial:
            return "lbStr".localized()
        case .unknow:
            return ""
        }
    }

    var distance: String {
        switch self {
        case .metric:
            return "kmStr".localized()
        case .imperial:
            return "miStr".localized()
        case .unknow:
            return ""
        }
    }

    var time: String {
        return "secStr".localized()
    }

    var units: [String] {
        switch self {
        case .metric:
            return [
                "gStr".localized(),
                "kgStr".localized(),
                "cmStr".localized(),
                "mStr".localized(),
                "percentStr".localized()
            ]
        case .imperial:
            return [
                "lbStr".localized(),
                "inStr".localized(),
                "ftStr".localized(),
                "percentStr".localized()
            ]
        case .unknow:
            return []
        }
    }
}
