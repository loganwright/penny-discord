import Foundation

struct Response {
    var data: Data?
    var response: URLResponse?
    var error: Error?
}

extension Response {
    func map<C: Decodable>(to type: C.Type = C.self) throws -> C {
        if let error = error { throw error }
        guard let data = data else { throw "no body found" }

        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(C.self, from: data)
    }
}
