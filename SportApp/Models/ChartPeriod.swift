import Foundation

enum ChartPeriod: CaseIterable {
    case month
    case year
    case allTime

    var localizedTitle: String {
        switch self {
        case .month:
            "monthStr".localized()
        case .year:
            "yearStr".localized()
        case .allTime:
            "allTimeStr".localized()
        }
    }
}
