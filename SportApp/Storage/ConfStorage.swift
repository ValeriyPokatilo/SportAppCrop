import Foundation
import RxSwift
import RxRelay

final class ConfStorage {

    static let shared = ConfStorage()

    private let fileName = "Configuration.plist"
    private let confRelay = BehaviorRelay<Configuration>(value: Configuration())

    var confObservable: Observable<Configuration> {
        return confRelay.asObservable()
    }

    var conf: Configuration {
        return confRelay.value
    }

    private init() {
        loadFromPlist()
    }

    private var plistURL: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent(fileName)
    }

    private func saveToPlist() {
        DispatchQueue.global(qos: .background).async {
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(self.confRelay.value)
                try data.write(to: self.plistURL)
            } catch {
                AnalyticsManager.shared.logError("Conf save error: \(error.localizedDescription)")
            }
        }
    }

    private func loadFromPlist() {
        let url = plistURL
        let decoder = PropertyListDecoder()

        if let data = try? Data(contentsOf: url),
           let configuration = try? decoder.decode(Configuration.self, from: data) {
            confRelay.accept(configuration)
        }
    }

    func updateConfiguration(_ newConfig: Configuration) {
        confRelay.accept(newConfig)
        saveToPlist()
    }
}
