import Sword
import Foundation

let base = "https://penny.ngrok.io"

struct CoinResponse: Codable {
    let coin: Coin
    let total: Int
}

func giveCoins(to: [String], from: String, respond: Message) throws {
    let coins = to.map { id in Coin(source: "discord", to: id, from: from, reason: "twas but a gift") }
    let url = base + "/coins"

    try Request.post(url, coins).run { resp in
        let resp = try resp.map(to: [CoinResponse].self)
        let messages = resp.map { "<@\($0.coin.to)> now has \($0.total) coins." }
        let message = messages.joined(separator: "\n")
        respond.reply(with: message)
    }
}

typealias Session = URLSession
typealias Request = URLRequest

import Sword

let PENNY_AUTH_TOKEN = "12345"

extension URLRequest {
    static func get(_ url: String) -> URLRequest {
        return base("GET", url)
    }

    static func get<C: Encodable>(_ url: String, _ body: C) throws -> URLRequest {
        var req = get(url)
        try req.addBody(body)
        return req
    }

    static func post(_ url: String) -> URLRequest {
        return base("POST", url)
    }

    static func post<C: Encodable>(_ url: String, _ body: C) throws -> URLRequest {
        var req = post(url)
        try req.addBody(body)
        return req
    }

    static func base(_ method: String, _ url: String) -> URLRequest {
        let url = URL(string: url)!
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("Bearer \(PENNY_AUTH_TOKEN)", forHTTPHeaderField: "Authorization")
        return req
    }

    mutating func addBody<C: Encodable>(_ body: C) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(body)
        httpBody = data
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        addValue("application/json", forHTTPHeaderField: "Accept")
    }

    func run(with handler: @escaping (Response) throws -> Void) {
//        let session = URLSession(configuration: .default)
        URLSession.shared.dataTask(with: self) { data, response, error in
            let resp = Response(data: data, response: response, error: error)
            do {
                try handler(resp)
            } catch { print("whoops: \(error)") }
        }.resume()
    }
}

struct Response {
    var data: Data?
    var response: URLResponse?
    var error: Error?
}

extension Data {
    func log() {
        print(String(data: self, encoding: .utf8))
    }
}

extension String: Error {}

extension Response {
    func map<C: Decodable>(to type: C.Type = C.self) throws -> C {
        if let error = error { throw error }
        guard let data = data else { throw "no body found" }

        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(C.self, from: data)
    }
}
