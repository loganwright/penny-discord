import Foundation

public struct Coin: Codable {
    public let id: UUID?
    public let source: String
    public let to: String
    public let from: String
    public let reason: String
    public let value: Int

    public init(
        source: String,
        to: String,
        from: String,
        reason: String,
        value: Int = 1,
        meta: String? = nil
    ) {
        self.id = nil
        self.source = source
        self.to = to
        self.from = from
        self.reason = reason
        self.value = value
    }
}
