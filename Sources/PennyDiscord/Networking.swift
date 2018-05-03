import Foundation

typealias Request = URLRequest

extension Request {
    static func get(_ url: String) -> URLRequest {
        return base("GET", url)
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
        let session = URLSession(configuration: .default)
        session.dataTask(with: self) { data, response, error in
            let resp = Response(data: data, response: response, error: error)
            do {
                try handler(resp)
            } catch { print("whoops: \(error)") }
            }.resume()
    }
}
