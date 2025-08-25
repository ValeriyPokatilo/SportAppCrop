import Foundation

struct Configuration: Codable {
    var defaultUnit: MSystem = .unknow
    var timerConf: TimerConf? = TimerConf(isEnabled: true, value: 90)
    var currentInfoTab: Int? = 0
    var rights: Rights = .nothing
}
