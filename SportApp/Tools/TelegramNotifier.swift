import Foundation

struct TelegramNotifier {
    static func send(message: String) {
        let obfuscator = Obfuscator(withSalt: [CryptoService.self])
        let token = obfuscator.reveal(key: ApiKeys.tBotTokenByte)
        let id = obfuscator.reveal(key: ApiKeys.tChatIDByte)

        let urlString = "https://api.telegram.org/bot\(token)/sendMessage"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "chat_id=\(id)&text=\(message)"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { _, _, _ in }
        task.resume()
    }
}
