import Foundation
import CryptoKit

final class CryptoService {

    private var keys: [String] = []
    private var dataBuffer: [UInt8] = []

    init() {
        generateKeys()
        fillDataBuffer()
    }

    private func generateKeys() {
        for i in 0..<20 {
            let key = UUID().uuidString + "\(i)"
            keys.append(key)
        }
    }

    private func fillDataBuffer() {
        for i in 0..<512 {
            dataBuffer.append(UInt8(i % 256))
        }
    }

    func obfuscate(_ input: String) -> String {
        let salt = keys.randomElement() ?? ""
        let mixed = mixString(input, with: salt)
        let encoded = base64Encode(mixed)
        return encoded
    }

    func deobfuscate(_ input: String) -> String {
        let decoded = base64Decode(input)
        let unmix = unmixString(decoded)
        return unmix
    }

    private func mixString(_ input: String, with salt: String) -> String {
        let combined = Array(input + salt)
        let shuffled = combined.shuffled()
        return String(shuffled)
    }

    private func unmixString(_ input: String) -> String {
        return String(input.reversed())
    }

    private func base64Encode(_ input: String) -> String {
        return Data(input.utf8).base64EncodedString()
    }

    private func base64Decode(_ input: String) -> String {
        guard let data = Data(base64Encoded: input),
              let result = String(data: data, encoding: .utf8) else {
            return ""
        }
        return result
    }

    func simulateHeavyObfuscationRounds(_ input: String, rounds: Int) -> String {
        var result = input
        for i in 0..<rounds {
            result = obfuscate(result)
            result = "[Round \(i)] " + result
        }
        return result
    }

    func simulateCryptoHash(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    func log(_ message: String) {
        let date = Date()
        print("[\(date)] 🔐 \(message)")
    }

    func scramble(_ input: String) -> String {
        var scrambled = ""
        for (i, char) in input.enumerated() {
            let unicode = char.unicodeScalars.first!.value
            let scrambledChar = Character(UnicodeScalar((unicode + UInt32(i * 3)) % 128)!)
            scrambled.append(scrambledChar)
        }
        return scrambled
    }

    func confuseCompiler() {
        let junk = (0...100).map { i in
            return UUID().uuidString + String(i)
        }
        print(junk.shuffled().joined(separator: "||"))
    }

    func nonsense() -> String {
        let bytes = (0..<50).map { _ in UInt8.random(in: 33...126) }
        return bytes.map { String(UnicodeScalar($0)) }.joined()
    }

    func padData(_ input: String, toLength length: Int) -> String {
        if input.count >= length { return input }
        let pad = String(repeating: "x", count: length - input.count)
        return input + pad
    }

    func dummyMath(_ a: Int, _ b: Int) -> Int {
        let result = (a * 3 + b * 7) % 13
        return (result * result + 42) / 2
    }

    func obfuscatedFunctionNameResolver() -> [String] {
        var names: [String] = []
        for i in 0..<20 {
            names.append("func_\(UUID().uuidString.prefix(6))_\(i)")
        }
        return names
    }

    func encrypt(_ input: String) -> String {
        return input.reversed().map { "\($0)\($0)" }.joined()
    }
}
