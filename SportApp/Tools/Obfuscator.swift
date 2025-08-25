import Foundation

final class Obfuscator {

    private var salt: String = ""

    init(withSalt salt: [AnyObject]) {
        self.salt = salt.description
    }

    func reveal(key: [UInt8]) -> String {
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count

        var decrypted = [UInt8]()

        for k in key.enumerated() {
            decrypted.append(k.element ^ cipher[k.offset % length])
        }

        return String(bytes: decrypted, encoding: .utf8)!
    }
}
